function [ output ] = classification( pointsCombined )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

clear; close; clc; 


ratio = 0.9;     

var = length(pointsCombined);
trainingInputs = pointsCombined(2:end,1:var*ratio);
testInputs = pointsCombined(2:end, var*ratio+1:end);
trainingTargets = pointsCombined(1, 1:var*ratio);
testTargets = pointsCombined(1, var*ratio+1:end);
testFace = [];
for k = 1:length(pointsCombined)
    if pointsCombined(1,k) == 1
        testFace = [testFace pointsCombined(:,k)];
    end
end
testTargetsFace = testFace(1,:);
testInputsFace = testFace(2:end,:);

trainingClassifier = [trainingTargets; trainingInputs];

[trainedClassifier, validationAccuracy] = quadraticSVM(trainingClassifier);
[Accuracy]  = runClassifier(trainedClassifier, testInputs, testTargets);
[AccuracyFace] = runClassifier(trainedClassifier, testInputsFace, testTargetsFace);
Accuracy
AccuracyFace
% figure; plot(testTargets);hold on; plot(yfit, '*r');


end

