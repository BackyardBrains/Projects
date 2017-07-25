function [ out ] = startClassifier( erps, outputClasses )

disp('Start Classifier')
out = [];
channels = [1 2 4];%we use only some of the channels



allInputs = [];
for ch =1:length(channels)
    allInputs = [allInputs erps(:,:,ch)];
end

outputClasses(outputClasses>4) = 0;



%make output variable
out.trainingInputs = allInputs;
out.trainingOutputs = outputClasses';

disp('Train SVM')
%train network
trainedClassifier = trainRTERP( out );

global classifier

classifier = trainedClassifier;
disp('Deploy')
deployClassifier;

% 
% %predict output for test data
% predictedOutputs = trainedClassifier.predictFcn(data.testInputs);
% 
% %calculate outputs for test data
% accuracyOnTestData = 1- sum(abs(predictedOutputs - data.testOutputs))/length(predictedOutputs)
% 
% plotconfusion(data.testOutputs',predictedOutputs', 'Face[1] / Non-Face[0] Classification ');









end

