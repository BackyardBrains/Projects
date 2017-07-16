function [ out ] = prepareSVMData(db, subjectIndex)
%Class uses raw ERP responses for subject with subjectIndex and prepare
%training and test set for classification. 
%Classification task is to classify face vs other image classes

%we aliminate first part of EEG ERP 
startOfImportantPart = 250;

selectedClass = 1;%we train network to recognize only one class vs other classes of images
channels = [1 2 4];%we use only some of the channels
allSelectedClass = [];%input data for other classes 


%concat all selected channels in one big input vector
%use only raw samples from startOfImportantPart to end of raw ERP
for ch =1:length(channels)
allSelectedClass = [allSelectedClass db{subjectIndex}.erp{selectedClass}.rawEEG(:,startOfImportantPart:end,ch)];
end

allOther = [];
for class=1:4
    
    if(selectedClass ~= class)%for other classes of images
        
        concatedClass = [];
        for ch =1:length(channels)
            concatedClass = [concatedClass db{subjectIndex}.erp{class}.rawEEG(:,startOfImportantPart:end,ch)];
        end
        allOther = [allOther; concatedClass];
    end
end

% make training and test set so that we have same number of examples for
% both classes
numberOfSelectedClassExample = size(allSelectedClass,1);
randSelectedNonClass= randperm(numberOfSelectedClassExample);
allOther = allOther(randSelectedNonClass,:);

%take 100*division percent of data for training and rest for testing
division = 0.75;
divisionIndex = ceil(division*numberOfSelectedClassExample);

%get training data
trainingInputs = [allSelectedClass(1:divisionIndex,:); allOther(1:divisionIndex,:)];
trainingOutputs = [ones(1, divisionIndex) zeros(1, divisionIndex)]';

%get test data
testInputs = [allSelectedClass(divisionIndex+1:end,:); allOther(divisionIndex+1:end,:)];
testOutputs = [ones(1,numberOfSelectedClassExample-divisionIndex) zeros(1,numberOfSelectedClassExample-divisionIndex)]';

%make output variable
out.trainingInputs = trainingInputs;
out.testInputs = testInputs;
out.trainingOutputs = trainingOutputs;
out.testOutputs = testOutputs;

end

