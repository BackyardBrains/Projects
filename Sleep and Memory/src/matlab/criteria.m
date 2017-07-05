[s,f,t] = spectrogram(data(1:end)-mean(data),90000,100,[],fs,'yaxis');
p = abs(s);

deltaIndex = find(f>0.5 & f<3);
deltam = p(deltaIndex, :);
meanDM = mean(deltam);

powerCriteria = meanDM>6;
timeCriteria = t>18*60;

powerAndTime = powerCriteria & timeCriteria;
consistencyCriteria = [];
for i=6:length(powerAndTime)
    if(sum(powerAndTime(i-5:i))>2)
        consistencyCriteria = [consistencyCriteria 1];
    else
        consistencyCriteria = [consistencyCriteria 0];
    end
end

consistencyCriteria = [0 0 0  0 0 consistencyCriteria];
finalCriteria = powerCriteria & timeCriteria & consistencyCriteria;