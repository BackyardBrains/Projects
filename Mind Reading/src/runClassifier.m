function [Accuracy1000, Accuracy500] = runClassifier(trainedClassifier, processedLowFreqPSB, processedSubsampledResultSB)

yfit = trainedClassifier.predictFcn(processedLowFreqPSB);
% figure; plot(yfit,'-*r'); hold on; plot(processedSubsampledResultSB, 'b');
Accuracy1000 = 1- (sum(abs(yfit-processedSubsampledResultSB')>0.5)/length(yfit));

xfit =[];
for k=1:length(yfit)
    if k == 1
        xfit = [xfit; yfit(k:k+6)];
    elseif rem(k,25)==0
        xfit = [xfit; yfit(k:k+6)];
    end
end


testSubsampledResultSB = [];
for k=1:length(processedSubsampledResultSB)
    if k == 1
        testSubsampledResultSB = [testSubsampledResultSB; processedSubsampledResultSB(k:k+6)'];
    elseif rem(k,25)==0
        testSubsampledResultSB = [testSubsampledResultSB; processedSubsampledResultSB(k:k+6)'];
    end
end
testSubsampledResultSB = testSubsampledResultSB';
% figure; plot(xfit,'-*r'); hold on; plot(testSubsampledResultSB, 'b');
Accuracy500 = 1- (sum(abs(xfit-testSubsampledResultSB')>0.5)/length(xfit));
end