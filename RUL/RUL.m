%%
load('expTrainTables.mat')
mdl = exponentialDegradationModel('LifeTimeUnit',"hours");
fit(mdl,expTrainTables,"Time","Condition")
load('expTestData.mat')
threshold = 500;

%%
N = height(expTestData);

for t = 1:N
%    CurrentDataSample = expTestData(t);    
   update(mdl,[expTestData.Time(t) expTestData.Condition(t)]) % 날짜마다 데이터 샘플을 입력하여 모델 업데이트
   mdlParameters(t,:) = [mdl.Theta mdl.Beta mdl.Rho]; % 그래프 그리는데 필요한 값 % 신뢰도모델의 형상계수 
   % Compute RUL only if the data indicates a change in slope.
   if ~isempty(mdl.SlopeDetectionInstant)
      [EstRUL(t),CI(t,:)] = predictRUL(mdl,[expTestData.Time(t) expTestData.Condition(t)],threshold); % EstRUL - 잔여수명 계산, CI - 신뢰도 구간
   end 
   trueRUL = N - t + 1;

end

%% 형상 계수 변화 그래프
figure
Time = hours(1:N)';
tStart = mdl.SlopeDetectionInstant; % slope detection time instant
plot(Time,mdlParameters);
hold on
plot([tStart, tStart],[-1,2],'k--')
legend({'\theta(t)','\beta(t)','\rho(t)','Slope detection instant'},'Location','best')
hold off
%% 잔여수명과 신뢰도 곡선 그래프 (GUI에 그릴 그림)
Time=expTestData.Time;
figure
plot(Time,EstRUL,'b.-',Time,CI,'c')
title('Estimated RUL at Time t')
xlabel('t')
ylabel('Estimated RUL')
legend({'Predicted RUL','Confidence bound','Confidence bound'})