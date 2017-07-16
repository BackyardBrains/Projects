function [ out] = classifyRawERP( data )

trainingSet = [data.trainingOutputs data.trainingInputs];

[trainedClassifier, validationAccuracy] = linearRawSVM(trainingSet);
validationAccuracy
predictedOutputs = trainedClassifier.predictFcn(data.testInputs);

accuracyOnTestData = 1- sum(abs(predictedOutputs - data.testOutputs))/length(predictedOutputs)

plotconfusion(data.testOutputs',predictedOutputs')
