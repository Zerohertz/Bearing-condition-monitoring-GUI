function tab = makeLearningData(raw, Winsize, lab)
i = 0;
j = 0;
while(j + Winsize <= length(raw))%(i < length(raw) - Winsize + 1)
    sam = raw(j + 1:j + Winsize);
    mn(i + 1) = mean(sam);
    sd(i + 1) = std(sam);
    rm(i + 1) = rms(sam);
    sk(i + 1) = skewness(sam);
    ku(i + 1) = kurtosis(sam);

    label(i + 1) = lab;
    i = i + 1;
    j = j + 1000;
    disp(i/(length(raw)/1000)*100)
end
tab = table(mn', sd', rm', sk', ku', label', 'VariableNames', {'Mean', 'STD', 'RMS', 'Skewness', 'Kurtosis', 'Label'});
end


