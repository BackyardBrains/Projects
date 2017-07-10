clear all; close all; clc; clear Workspace;

single = 1;
all = 2;
eegdata = data(single);
f1 = diff(eegdata(1:end, 6))<-std(diff(eegdata(1:end, 6)));
% eegdata = data(all);
%[classes, intervals]  = preprocessing(eegdata, f1);
%initialData = [classes' intervals']';
% [classesAveraged, averaged] = averagingvectors(classes, intervals);
% averagedData = [classesAveraged' averaged']';
% kmeans(classesAveraged, averaged);
ratio = 0.9;
[newDatumSB] = spectralDecomposition(eegdata, f1);      
targets = newDatumSB(1,:)';

newTargets = targets;
newTargets(newTargets~=1) = 0;

inputs = newDatumSB(2:end,:)';
trainingInputs = inputs(1:length(inputs)*ratio)';
testInputs = inputs(round(length(inputs)*ratio)+1:end,:)';
lengthOfData = size(newDatumSB,2);
var = round(lengthOfData*ratio);
trainingData = newDatumSB(:,1:var);
testData = newDatumSB(:, var+1:end);
[trainedClassifier, validationAccuracy] = lsvm(trainingData);
class1 = targets;
class1(class1~=1) = 0;
trainingTargets1 = class1(1:length(class1)*ratio);
testTargets1 = class1(round(length(inputs)*ratio)+1:end);
class2 = targets;
class2(class2~=2) = 0;
class2(class2==2) = 1;
trainingTargets2 = class2(1:length(class2)*ratio);
testTargets2 = class2(round(length(inputs)*ratio)+1:end);
class3 = targets;
class3(class3~=3) = 0;
class3(class3==3) = 1;
trainingTargets3 = class3(1:length(class3)*ratio);
testTargets3 = class3(round(length(inputs)*ratio)+1:end);
class4 = targets;
class4(class4~=1) = 0;
class4(class4==4) = 1;
trainingTargets4 = class4(1:length(class4)*ratio);
testTargets4 = class4(round(length(inputs)*ratio)+1:end);

testFace = [];
testHouse = [];
testScene = [];
testWeird = [];
for k=1:length(testData)
    if testData(1,k)==1
       testFace = [testFace testData(:,k)];
    elseif testData(1,k)==2
       testHouse = [testHouse testData(:,k)];
    elseif testData(1,k)==3
       testScene = [testScene testData(:,k)];
    elseif testData(1,k)==4
       testWeird = [testWeird testData(:,k)];
    end
end

[Accuracy1000, Accuracy500]  = runClassifier(trainedClassifier, testData(2:end,:), testData(1,:));
Accuracy1000
Accuracy500
[AccuracyFace1000, AccuracyFace500]  = runClassifier(trainedClassifier, testFace(2:end,:), testFace(1,:));
AccuracyFace1000
AccuracyFace500
[AccuracyHouse1000, AccuracyHouse500]  = runClassifier(trainedClassifier, testHouse(2:end,:), testHouse(1,:));
AccuracyHouse1000
AccuracyHouse500
[AccuracyScene1000, AccuracyScene500]  = runClassifier(trainedClassifier, testScene(2:end,:), testScene(1,:));
AccuracyScene1000
AccuracyScene500
[AccuracyWeird1000, AccuracyWeird500]  = runClassifier(trainedClassifier, testWeird(2:end,:), testWeird(1,:));
AccuracyWeird1000
AccuracyWeird500

% 
% [newDatumSB2] = spectralDecomposition2(eegdata, f1);
% lengthOfData2 = size(newDatumSB2,2);
% var2 = round(lengthOfData2*ratio);
% trainingData2 = newDatumSB2(:,1:var2);
% testData2 = newDatumSB2(:, var2+1:end);
% [trainedClassifier2, validationAccuracy2] = lsvm3(trainingData2);
% testFace2 = [];
% testHouse2 = [];
% testScene2 = [];
% testWeird2 = [];
% for k=1:780
%     if testData2(1,k)==1
%        testFace2 = [testFace2 testData2(:,k)];
%     elseif testData2(1,k)==2 
%        testHouse2 = [testHouse2 testData2(:,k)];
%     elseif testData2(1,k)==3
%        testScene2 = [testScene2 testData2(:,k)];
%     elseif testData2(1,k)==4
%        testWeird2 = [testWeird2 testData2(:,k)];
%     end
% end
% 
% [Accuracy10002, Accuracy5002]  = runClassifier(trainedClassifier2, testData2(2:end,:), testData2(1,:));
% Accuracy10002
% Accuracy5002
% [AccuracyFace10002, AccuracyFace5002]  = runClassifier(trainedClassifier2, testFace2(2:end,:), testFace2(1,:));
% AccuracyFace10002
% AccuracyFace5002
% [AccuracyHouse10002, AccuracyHouse5002]  = runClassifier(trainedClassifier2, testHouse2(2:end,:), testHouse2(1,:));
% AccuracyHouse10002
% AccuracyHouse5002
% [AccuracyScene10002, AccuracyScene5002]  = runClassifier(trainedClassifier2, testScene2(2:end,:), testScene2(1,:));
% AccuracyScene10002
% AccuracyScene5002
% [AccuracyWeird10002, AccuracyWeird5002]  = runClassifier(trainedClassifier2, testWeird2(2:end,:), testWeird2(1,:));
% AccuracyWeird10002
% AccuracyWeird500