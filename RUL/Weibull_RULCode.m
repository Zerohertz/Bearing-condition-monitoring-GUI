
t3=linspace(1,2800,2800); 
%
%% 변동성을 고려한 Health indicator의 선택

%신뢰성 모델의 형상 계수 추정을 위한 데이터 선정
linTrainVectors{1, 1}(:,1)=t3;
linTrainVectors{2, 1}(:,1)=t3;
linTrainVectors{3, 1}(:,1)=t3;
linTrainVectors{4, 1}(:,1)=t3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
linTrainVectors{1, 1}(:,2)=Feature{1, 1}(:,2); %data;
linTrainVectors{2, 1}(:,2)=Feature{1, 1}(:,6); %data
linTrainVectors{3, 1}(:,2)=Feature{1, 1}(:,10); %data
linTrainVectors{4, 1}(:,2)=Feature{1, 1}(:,12); %data


% linTrainVectors{5, 1}(:,2)=Feature{1, 1}(:,3); %data

%%

linTrainVectors2{1,1}=linTrainVectors{1, 1}(1500:2745,1)
linTrainVectors2{2,1}=linTrainVectors{2, 1}(1500:2745,1)
linTrainVectors2{3,1}=linTrainVectors{3, 1}(1500:2745,1)
linTrainVectors2{4,1}=linTrainVectors{4, 1}(1500:2745,1)

% mdl = linearDegradationModel;
Model = exponentialDegradationModel('LifeTimeUnit',"hours");

Model=exponentialDegradationModel
fit(Model,linTrainVectors,"Time","Condition")
% fit(mdl,linTrainVectors,"Date","Energy") % 학습데이터에 대해 형상 파라미터 추정
Model.Prior
%%
% TestData=table(trainDataSelected3.Energy,'VariableNames',{'Energy'});

t3=linspace(1500,2745,1245); 
t3=linspace(1,2800,2800); 

TestData=table(t3',linTrainVectors{3, 1}(1:end,2),'VariableNames',{'Time' 'Condition'});


Model.SlopeDetectionLevel = 0.2; % 기울기 감지레벨
% 0.1로 하면 아주 초기 시점임

threshold =1000;
%%

timeUnit = '60 min';
%%
N = height(TestData);

totalDay=N;

for t = 1:N
%    CurrentDataSample = TestData(t);    
   update(Model,[TestData.Time(t) TestData.Condition(t)]) % 날짜마다 데이터 샘플을 입력하여 모델 업데이트
   ModelParameters(t,:) = [Model.Theta Model.Beta Model.Rho]; % 그래프 그리는데 필요한 값 % 신뢰도모델의 형상계수 
   % Compute RUL only if the data indicates a change in slope.
   if ~isempty(Model.SlopeDetectionInstant)
      [EstRUL(t),CI(t,:)] = predictRUL(Model,[TestData.Time(t) TestData.Condition(t)],threshold); % EstRUL - 잔여수명 계산, CI - 신뢰도 구간
   end 
   trueRUL = totalDay - t + 1;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 형상 계수 변화 그래프
figure
Time = hours(1:N)';
tStart = Model.SlopeDetectionInstant; % slope detection time instant
plot(Time,ModelParameters);
hold on
plot([tStart, tStart],[-1,2],'k--')
legend({'\theta(t)','\beta(t)','\rho(t)','Slope detection instant'},'Location','best')
hold off
%% 잔여수명과 신뢰도 곡선 그래프 (GUI에 그릴 그림)
figure
plot(Time,EstRUL,'b.-',Time,CI,'c')
title('Estimated RUL at Time t')
xlabel('t')
ylabel('Estimated RUL')
legend({'Predicted RUL','Confidence bound','Confidence bound','Slope detection instant'})
%%  에러율 그래프
Error=(EstRUL-trueRULs)./trueRULs;
plot(Error)
%
Time2=hours(1501:1:2745)';
figure
plot(Time,EstRUL,'b.-',Time,CI,'c')
title('Estimated RUL at Time t')
xlabel('t')
ylabel('Estimated RUL')
legend({'Predicted RUL','Confidence bound','Confidence bound'})

%% 알파-람다 그래프
breaktime = datetime(2012,11,22,16,16,35)
breakpoint = find(trainDataSelected3.Date < breaktime, 1, 'last');

alpha = 0.2;
detectTime = Model.SlopeDetectionInstant;
[prob,h1,h2]= helperAlphaLambdaPlot(alpha, trueRULs, estRULs, CIRULs, ...
    pdfRULs, detectTime, breakpoint, timeUnit);
title('\alpha-\lambda Plot')