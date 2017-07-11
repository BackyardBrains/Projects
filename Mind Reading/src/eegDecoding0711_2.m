clear all; close all; clc; clear Workspace;

single = 1;
all = 2;
eegdata = data(single);
f1 = diff(eegdata(1:end, 6))<-std(diff(eegdata(1:end, 6)));

ratio = 0.9;
[newDatumSB] = spectralDecomposition(eegdata, f1); 
divIndex = ceil(ratio*length(f1));

classThatWeTest = 1;%face


bulkTrainingInputs = newDatumSB(:,1:divIndex);
bulkTrainingOutputs = f1(1:divIndex);
bulkTestInputs = newDatumSB(:,divIndex+1:end);
bulkTestOutputs = f1(divIndex+1:end);

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



% 
% 
% 
% trim1 = [];
% trim0 = [];
% for k = 1:length(newDatumSB)
%     if newDatumSB(1,k) == 1
%         trim1 = [trim1 newDatumSB(:,k)];
%     else
%         trim0 = [trim0 newDatumSB(:,k)];
%     end
% end 
% rando = randperm(length(trim1));
% trimmed0 = trim0(:,rando);
% mergedData = [trim1'; trim0']';
% rando2 = randperm(length(mergedData));
% trimmedData = mergedData(:,rando2);
% 
% targets = trimmedData(1,:)';
% 
% 
% newTargets1 = targets;
% newTargets1(newTargets1~=1) = 0;
% newTargets2 = targets;
% newTargets2(newTargets2~=2) = 0;
% newTargets2(newTargets2==2) = 1;
% newTargets3 = targets;
% newTargets3(newTargets3~=3) = 0;
% newTargets3(newTargets3==3) = 1;
% newTargets4 = targets;
% newTargets4(newTargets4~=4) = 0;
% newTargets4(newTargets4==4) = 1;
% 
% 
% trainingTargets1 = newTargets1(1:round(length(newTargets1))*ratio);
% testTargets1 = newTargets1(round(length(newTargets1)*ratio)+1:end);
% trainingTargets2 = newTargets2(1:round(length(newTargets2))*ratio);
% testTargets2 = newTargets2(round(length(newTargets2)*ratio)+1:end);
% trainingTargets3 = newTargets3(1:round(length(newTargets3))*ratio);
% testTargets3 = newTargets3(round(length(newTargets3)*ratio)+1:end);
% trainingTargets4 = newTargets4(1:round(length(newTargets4))*ratio);
% testTargets4 = newTargets4(round(length(newTargets4)*ratio)+1:end);
% 
% inputs = trimmedData(2:end,:)';
% trainingInputs = inputs(1:round(size(inputs,1))*ratio,:);
% testInputs = inputs(round(size(inputs,1)*ratio)+1:end,:);
% % lengthOfData = size(newDatumSB,2);
% % var = round(lengthOfData*ratio);
% % trainingData = newDatumSB(:,1:var);
% % testData = newDatumSB(:, var+1:end);
% % [trainedClassifier, validationAccuracy] = lsvm(trainingData);
% % class1 = targets;
% % class1(class1~=1) = 0;
% % trainingTargets1 = class1(1:length(class1)*ratio);
% % testTargets1 = class1(round(length(inputs)*ratio)+1:end);
% % class2 = targets;
% % class2(class2~=2) = 0;
% % class2(class2==2) = 1;
% % trainingTargets2 = class2(1:length(class2)*ratio);
% % testTargets2 = class2(round(length(inputs)*ratio)+1:end);
% % class3 = targets;
% % class3(class3~=3) = 0;
% % class3(class3==3) = 1;
% % trainingTargets3 = class3(1:length(class3)*ratio);
% % testTargets3 = class3(round(length(inputs)*ratio)+1:end);
% % class4 = targets;
% % class4(class4~=1) = 0;
% % class4(class4==4) = 1;
% % trainingTargets4 = class4(1:length(class4)*ratio);
% % testTargets4 = class4(round(length(inputs)*ratio)+1:end);
% 
% x = inputs';
% t = newTargets4';

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainbr';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 30;
net = patternnet(hiddenLayerSize);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;

% Train the Network
[net,tr] = train(net,trainingInputs,trainingTargets);

% Test the Network
y = net(testInputs);
% e = gsubtract(testTargets1',y);
% performance = perform(net,testTargets',y)
% tind = vec2ind(testTargets');
% yind = vec2ind(y);
% percentErrors = sum(tind ~= yind)/numel(tind)
% sum(abs((testTargets1')-(y>0.5)))/length(testTargets1')
% 
% 1 - (sum(abs((testTargets1')-y)>0.5)/length(testTargets1'))
% % figure, plotperform(tr)
% 1- (sum(abs(yfit-processedSubsampledResultSB')>0.5)/length(yfit));
% View the Network
% view(net)

indexesWhenClassIsON = find(testTargets>=0.5);
indexesWhenClassIsOFF = find(testTargets<0.5);
thresholdedOutput = double(y>0.5);
truePositives = thresholdedOutput(indexesWhenClassIsON);
percentageOfTruePositives = 100*(sum(truePositives)/length(indexesWhenClassIsON))

falsePositives = thresholdedOutput(indexesWhenClassIsOFF);
percentageOfFalsePositives = 100*(sum(falsePositives)/length(indexesWhenClassIsOFF))

percentageOfTrueNegatives = 100-percentageOfFalsePositives





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
