function [ out ] = startClassifier()

global erps;
global outputClasses;
global classOfImage;

outputClasses = classOfImage;

disp('Start Classifier')
out = [];
channels = [1 2 4];%we use only some of the channels
faceClass = 1;

%prepare data
allSelectedClass = [];%input data for other classes 
faces = erps(outputClasses==faceClass,:,:);

for ch =1:length(channels)
    allSelectedClass = [allSelectedClass faces(:,:,ch)];
end


allOtherClassesEEG = erps(outputClasses~=faceClass,:,:);
allOther = [];
for ch =1:length(channels)
    allOther = [allOther allOtherClassesEEG(:,:,ch)];
end



% make training and test set so that we have same number of examples for
% both classes
numberOfSelectedClassExample = size(allSelectedClass,1);
randSelectedNonClass= randperm(numberOfSelectedClassExample);
allOther = allOther(randSelectedNonClass,:);

%get training data
trainingInputs = [allSelectedClass; allOther];
trainingOutputs = [ones(1, numberOfSelectedClassExample) zeros(1, numberOfSelectedClassExample)]';



%make output variable
out.trainingInputs = trainingInputs;
out.trainingOutputs = trainingOutputs;

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

