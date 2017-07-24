function [ out ] = prepareSVMData(d, varargin)
%Class uses raw ERP responses for subject with subjectIndex and prepare
%training and test set for classification. 
%Classification task is to classify face vs other image classes

%we aliminate first part of EEG ERP  
%GG.  We should index by time...
selectedClass = 1;%we train network to recognize only one class vs other classes of images
channels = [1 2 4];%we use only some of the channels
timeWindow = [-0.1 0.5];

for iarg= 1:2:(nargin-1),   % assume an even number of varargs
 
    switch lower(varargin{iarg}),

        case {'t', 'tw'}
            timeWindow = varargin{iarg+1};
            
        case {'channels', 'c'}
            channels = varargin{iarg+1};

        otherwise,

    end % end of switch
end % end of for iarg



allSelectedClass = [];%input data for other classes 

roiIndex = [min( find(d.erp{1}.t > timeWindow(1)) )
 max( find(d.erp{1}.t < timeWindow(2)) )];

%concat all selected channels in one big input vector
%use only raw samples from startOfImportantPart to end of raw ERP
for ch =1:length(channels)
allSelectedClass = [allSelectedClass d.erp{selectedClass}.trialERPs(:,roiIndex(1):roiIndex(2),ch)];
end

allOther = [];
for class=1:length(d.erp)
    
    if(selectedClass ~= class)%for other classes of images
        
        concatedClass = [];
        for ch =1:length(channels)
            concatedClass = [concatedClass d.erp{class}.trialERPs(:,roiIndex(1):roiIndex(2),ch)];
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

