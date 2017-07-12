
clear; close all; clc; clear Workspace;

single = 1;
all = 2;
%eegdata = data(single);

eegdata = audioread('../data/Joud_long.wav');


eegdata(1:end, 1) = - eegdata(1:end, 1);
eegdata(1:end, 2) = eegdata(1:end, 2);
eegdata(1:end, 5) = - eegdata(1:end, 5);
for k=1:5
   eegdata(1:end, k) = (eegdata(1:end, k) - mean(eegdata(1:end, k)))/std(eegdata(1:end, k));
end


f1 = diff(eegdata(1:end, 6))<-std(diff(eegdata(1:end, 6)));

ratio = 0.8;
[newDatumSB] = spectralDecomposition(eegdata, f1); 
divIndex = ceil(ratio*length(newDatumSB));

classThatWeTest = 1;%face

bulkTrainingInputs = newDatumSB(2:end,1:divIndex);
bulkTrainingOutputs = newDatumSB(1,1:divIndex);
bulkTestInputs = newDatumSB(2:end,divIndex+1:end);
bulkTestOutputs = newDatumSB(1,divIndex+1:end);





oneClassTrainingInputs = bulkTrainingInputs(:,find(bulkTrainingOutputs==classThatWeTest));
bulkZerosClassTrainingInputs = bulkTrainingInputs(:,find(bulkTrainingOutputs~=classThatWeTest));
numberOfOnesInTraining = size(oneClassTrainingInputs,2);
zerosClassTrainingInputs = bulkZerosClassTrainingInputs(:,randperm(numberOfOnesInTraining));

trainingInputs = [oneClassTrainingInputs zerosClassTrainingInputs];
trainingTargets = [ones(1,size(oneClassTrainingInputs,2)) zeros(1,size(zerosClassTrainingInputs,2))];


oneClassTestInputs = bulkTestInputs(:,find(bulkTestOutputs==classThatWeTest));
bulkZerosClassTestInputs = bulkTestInputs(:,find(bulkTestOutputs~=classThatWeTest));
numberOfOnesInTest = size(oneClassTestInputs,2);
zerosClassTestInputs = bulkZerosClassTestInputs(:,randperm(numberOfOnesInTest));

testInputs = [oneClassTestInputs zerosClassTestInputs];
testTargets = [ones(1,size(oneClassTestInputs,2)) zeros(1,size(zerosClassTestInputs,2))];


trainFcn = 'trainbr';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 60/100;
net.divideParam.valRatio = 20/100;
net.divideParam.testRatio = 20/100;

% Train the Network
[net,tr] = train(net,trainingInputs,trainingTargets);

% Test the Network
y = net(testInputs);

indexesWhenClassIsON = find(testTargets>=0.5);
indexesWhenClassIsOFF = find(testTargets<0.5);
thresholdedOutput = double(y>0.5);
truePositives = thresholdedOutput(indexesWhenClassIsON);
percentageOfTruePositives = 100*(sum(truePositives)/length(indexesWhenClassIsON))

falsePositives = thresholdedOutput(indexesWhenClassIsOFF);
percentageOfFalsePositives = 100*(sum(falsePositives)/length(indexesWhenClassIsOFF))

percentageOfTrueNegatives = 100-percentageOfFalsePositives
percentageOfFalseNegatives = 100 - percentageOfTruePositives

Accuracy = (percentageOfTruePositives+percentageOfTrueNegatives)/200





% 
% 
% testFace = [];
% testHouse = [];
% testScene = [];
% testWeird = [];
% for k=1:length(testData)
%     if testData(1,k)==1
%        testFace = [testFace testData(:,k)];
%     elseif testData(1,k)==2
%        testHouse = [testHouse testData(:,k)];
%     elseif testData(1,k)==3
%        testScene = [testScene testData(:,k)];
%     elseif testData(1,k)==4
%        testWeird = [testWeird testData(:,k)];
%     end
% end
% 
% [Accuracy1000, Accuracy500]  = runClassifier(trainedClassifier, testData(2:end,:), testData(1,:));
% Accuracy1000
% Accuracy500
% [AccuracyFace1000, AccuracyFace500]  = runClassifier(trainedClassifier, testFace(2:end,:), testFace(1,:));
% AccuracyFace1000
% AccuracyFace500
% [AccuracyHouse1000, AccuracyHouse500]  = runClassifier(trainedClassifier, testHouse(2:end,:), testHouse(1,:));
% AccuracyHouse1000
% AccuracyHouse500
% [AccuracyScene1000, AccuracyScene500]  = runClassifier(trainedClassifier, testScene(2:end,:), testScene(1,:));
% AccuracyScene1000
% AccuracyScene500
% [AccuracyWeird1000, AccuracyWeird500]  = runClassifier(trainedClassifier, testWeird(2:end,:), testWeird(1,:));
% AccuracyWeird1000
% AccuracyWeird500

% 
% [newDatumSB2] = spectralDecomposition2(eegdata, f1);
% 
% targets2 = newDatumSB2(1,:)';
% 
% newTargets12 = targets2;
% newTargets12(newTargets12~=1) = 0;
% newTargets22 = targets2;
% newTargets22(newTargets22~=2) = 0;
% newTargets22(newTargets22==2) = 1;
% newTargets32 = targets2;
% newTargets32(newTargets32~=3) = 0;
% newTargets32(newTargets32==3) = 1;
% newTargets42 = targets2;
% newTargets42(newTargets42~=4) = 0;
% newTargets42(newTargets42==4) = 1;
% 
% inputs2 = newDatumSB2(2:end,:)';
% trainingInputs2 = inputs2(1:length(inputs2)*ratio)';
% testInputs2 = inputs2(round(length(inputs2)*ratio)+1:end,:)';





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
