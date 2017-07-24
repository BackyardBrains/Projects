function [ trainedClassifier] = trainRTERP( data )

%make training set
trainingSet = [data.trainingOutputs data.trainingInputs];
%train SVM
[trainedClassifier, validationAccuracy] = linearRawSVM(trainingSet);
validationAccuracy
disp('Finish training')
