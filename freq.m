 function [f, P1] = freq(raw)
    SamplingRate = 25600;
    %NyqFreq = SamplingRate / 2;
    y = fft(raw);
    P2 = abs(y / length(raw));
    P1 = P2(1:fix(length(raw)/2) + 1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = SamplingRate * (0:(fix(length(raw)/2)))/length(raw);
end 