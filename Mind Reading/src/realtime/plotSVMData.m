function [ out ] = plotSVMData( erpsTraining, correctClassTraining, classifier, erpsTesting, correctClassesTesting )

%How to run this function:
%   clear
%   load('trainingRT-22-Jul-2017-12-53-38.mat')
%   erpsTraining = erps;
%   correctClassTraining = classOfImage;
%   load('resultsRT-22-Jul-2017-12-58-49.mat')
%   erpsTesting = erps;
%   correctClassesTesting = corectClasses;
%   plotSVMData( erpsTraining, correctClassTraining, classifier, erpsTesting, correctClassesTesting )
%


%%Process data from training
pcaDim = [2,3];
channels = [1 2 4];%we use only some of the channels
faceClass = 1;

%prepare data
allSelectedClass = [];%input data for other classes 
faces = erpsTraining(correctClassTraining==faceClass,:,:);

for ch =1:length(channels)
    allSelectedClass = [allSelectedClass faces(:,:,ch)];
end


allOtherClassesEEG = erpsTraining(correctClassTraining~=faceClass,:,:);
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




%% Lower dimension of input vector

coeff = pca(trainingInputs);
reducedDimension = coeff(:,1:3);
reducedDataTraining = trainingInputs * reducedDimension;

%plot training inputs with correct classes
corectClassesTraining = trainingOutputs==1;
plot(reducedDataTraining(corectClassesTraining,pcaDim(1)),reducedDataTraining(corectClassesTraining,pcaDim(2)),'bo')

xlabel('First PCA dimension')
ylabel('Second PCA dimension')
hold on;
nonFaceTraining = trainingOutputs~=1;
plot(reducedDataTraining(nonFaceTraining,pcaDim(1)),reducedDataTraining(nonFaceTraining,pcaDim(2)),'go')


%simulate classifier on training inputs
predictedClassesTraining = classifier.predictFcn(trainingInputs);
incorrectlyClassifiedTraining = abs(predictedClassesTraining - corectClassesTraining)>0;





%%lower dimensions of test inputs
testingInputs = [];
for ch =1:length(channels)
    testingInputs = [testingInputs erpsTesting(:,:,ch)];
end
reducedDataTesting = testingInputs * reducedDimension;
predictedClassesTesting= classifier.predictFcn(testingInputs);



plot(reducedDataTesting(correctClassesTesting==1,pcaDim(1)),reducedDataTesting(correctClassesTesting==1,pcaDim(2)),'bs')
plot(reducedDataTesting(correctClassesTesting~=1,pcaDim(1)),reducedDataTesting(correctClassesTesting~=1,pcaDim(2)),'gs')

incorrectlyClassifiedTesting = abs(predictedClassesTesting - (correctClassesTesting==1)')>0;


%plot incorrectly classified on training
plot(reducedDataTraining(incorrectlyClassifiedTraining,pcaDim(1)),reducedDataTraining(incorrectlyClassifiedTraining,pcaDim(2)),'rx')
%plot incorrectly classified on testing
plot(reducedDataTesting(incorrectlyClassifiedTesting,pcaDim(1)),reducedDataTesting(incorrectlyClassifiedTesting,pcaDim(2)),'rx')
legend('Face Training','Non Face Training', 'Face Testing', 'Non Face Testing','Incorrectly classified');

end