%_____Spectral Decomposition____________________________________________


function [processedSubsampledResultSB, processedLowFreqPSB,newDatumSB] = spectralDecompostion(eegdataSB, f1SB) 

% figure;
% title('Chanel 1');
% spectrogram(eegdataSB(:,1),1666,1600,1666,1666);
[s,f,t] = spectrogram(eegdataSB(:,1),1666,1600,1666,1666);
p = abs(s);
lowFreqP1SB = p(2:2:127,:)+p(3:2:128,:);
lowFreqP1SB = lowFreqP1SB./2;

% figure;
% title('Chanel 2');
% spectrogram(eegdataSB(:,2),1666,1600,1666,1666);
[s,f,t] = spectrogram(eegdataSB(:,2),1666,1600,1666,1666);
p = abs(s);
lowFreqP2SB = p(2:2:127,:)+p(3:2:128,:);
lowFreqP2SB = lowFreqP2SB./2;

% figure;
% title('Chanel 3');
% spectrogram(eegdataSB(:,3),1666,1600,1666,1666)
[s,f,t] = spectrogram(eegdataSB(:,3),1666,1600,1666,1666);
p = abs(s);
lowFreqP3SB = p(2:2:127,:)+p(3:2:128,:);
lowFreqP3SB = lowFreqP3SB./2;

% figure;
% title('Chanel 4');
% spectrogram(eegdataSB(:,4),1666,1600,1666,1666)
[s,f,t] = spectrogram(eegdataSB(:,4),1666,1600,1666,1666);
p = abs(s);
lowFreqP4SB = p(2:2:127,:)+p(3:2:128,:);
lowFreqP4SB = lowFreqP4SB./2;

% figure;
% title('Chanel 5')
% spectrogram(eegdataSB(:,5),1666,1600,1666,1666)
[s,f,t] = spectrogram(eegdataSB(:,5),1666,1600,1666,1666);
p = abs(s);
lowFreqP5SB = p(2:2:127,:)+p(3:2:128,:);
lowFreqP5SB = lowFreqP5SB./2;

lowFreqPSB = [lowFreqP1SB;lowFreqP2SB;lowFreqP3SB;lowFreqP4SB;lowFreqP5SB];

result = zeros(1,length(f1SB));

inside = 0;
indexOfLast = 0;
lengthOfImagePresentation = 1666;
for i=1:length(f1SB)
    if(inside>0)
        if(f1SB(i-1)==1 && f1SB(i)==0)
            result(indexOfLast) = result(indexOfLast) +1;
        end
        inside = inside +1;
        if(inside == lengthOfImagePresentation+1)
            result(indexOfLast:indexOfLast+lengthOfImagePresentation) = ones(1,lengthOfImagePresentation+1)*result(indexOfLast);
        end
        if(inside > 3000)
            inside = 0;
        end
    end
    if(f1SB(i)==1)
        
        if(inside == 0)
            inside = inside +1;
            result(i) = 1;
            indexOfLast = i;
        end
    end
    
end
result = result -2;
result(result==-2) = 5;

lengthOfPowerSpect = length(lowFreqPSB);
lengthOfResult = length(result);
elementCoef = lengthOfResult/lengthOfPowerSpect;
indexes = [1:elementCoef:lengthOfResult];
subsampledResultSB = result(round(indexes));

datumSB = [subsampledResultSB; lowFreqPSB];

processDatum = [];
for k = 1:length(datumSB)/2
    if datumSB(1,k)==1
        processDatum = [processDatum datumSB(:,k)];
    elseif datumSB(1,k)==2
        processDatum = [processDatum datumSB(:,k)];
    elseif datumSB(1,k)==3
        processDatum = [processDatum datumSB(:,k)];
    elseif datumSB(1,k)==4
        processDatum = [processDatum datumSB(:,k)];
    end
end

processedSubsampledResultSB = processDatum(1,:);
processedLowFreqPSB = processDatum(2:end,:);

f2SB = abs(diff(processedSubsampledResultSB))>std(abs(diff(processedSubsampledResultSB)));
dataPoint = [];
newDataMatrix = [];
newSubsampledResultSB = [];
for k =1:length(f2SB)-14
    if f2SB(:,k) == 1
        dataPoint = [dataPoint k+4];
        temp = processedLowFreqPSB(:,k+1:k+13); 
        newDataMatrix = [newDataMatrix temp];
        newSubsampledResultSB = [newSubsampledResultSB processedSubsampledResultSB(k+1:k+13)];
    end
end
    
%newLowFreqPSB = processedLowFreqPSB(:,dataPoint);
%newSubsampledResultSB = processedSubsampledResultSB(:,dataPoint);

newDatumSB = [newSubsampledResultSB; newDataMatrix];
end