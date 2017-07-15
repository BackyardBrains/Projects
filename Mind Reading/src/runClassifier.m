function [Accuracy] = runClassifier(trainedClassifier, testInputs, testTargets)

yfit = trainedClassifier.predictFcn(testInputs);
%figure; plot(yfit,'-*r'); hold on; plot(testTargets, 'b');
Accuracy = 1- (sum(abs(yfit-testTargets')>0.5)/length(yfit));

% xfit =[];
% for k=1:length(yfit)-12
%     if k == 1
%         xfit = [xfit; yfit(k:k+12)];
%     elseif rem(k,25)==0
%         xfit = [xfit; yfit(k:k+12)];
%     end
% end
% 
% 
% testSubsampledResultSB = [];
% for k=1:length(processedSubsampledResultSB)-12
%     if k == 1
%         testSubsampledResultSB = [testSubsampledResultSB; processedSubsampledResultSB(k:k+12)'];
%     elseif rem(k,25)==0
%         testSubsampledResultSB = [testSubsampledResultSB; processedSubsampledResultSB(k:k+12)'];
%     end
% end
% testSubsampledResultSB = testSubsampledResultSB';
% % figure; plot(xfit,'-*r'); hold on; plot(testSubsampledResultSB, 'b');
% Accuracy500 = 1- (sum(abs(xfit-testSubsampledResultSB')>0.5)/length(xfit));
end