function [ trainedClassifier] = trainRTERP( data )

%make training set
trainingSet = [data.trainingOutputs data.trainingInputs];
%train SVM
[trainedClassifier, validationAccuracy] = linearOnlineRTSVM(trainingSet);
validationAccuracy
disp('Finish training')
