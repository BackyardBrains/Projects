function [ trainedClassifier] = classifyRawERP( data )

%make training set
trainingSet = [data.trainingOutputs data.trainingInputs];
%train SVM
[trainedClassifier, validationAccuracy] = linearRawSVM(trainingSet);
validationAccuracy

%predict output for test data
predictedOutputs = trainedClassifier.predictFcn(data.testInputs);

%calculate outputs for test data
accuracyOnTestData = 1- sum(abs(predictedOutputs - data.testOutputs))/length(predictedOutputs)

plotconfusion(data.testOutputs',predictedOutputs', 'Face[1] / Non-Face[0] Classification ');
