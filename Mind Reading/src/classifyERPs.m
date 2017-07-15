function [ out ] = classifyERPs( d, varargin)
channels = [1,2,4];
ratio = 0.8;  

for iarg= 1:2:(nargin-1),   % assume an even number of varargs
 
    switch lower(varargin{iarg}),

        case {'channels', 'c'}
            channels = varargin{iarg+1};

        case {'ratio'}
            ratio = varargin{iarg+1};

        case ''

        otherwise,

    end % end of switch
end % end of for iarg )

 trainingSet = [];
 pictureColor = {'r', 'g', 'b', 'k'};
 

 
%Loop through all subjects.

figure;
hold on;

        
for iSubject = 1:size(d, 2)
    
    %Loop through ERP of all pictures
    for iPicture = 1:length(d{iSubject}.erp)
       

        %Find the 3 relevant ponits.
        for iCh = 1:length(channels)
       
           x(iCh) = max(d{iSubject}.erp{iPicture}.zscore( find( d{iSubject}.erp{iPicture}.t > 0.000 & d{iSubject}.erp{iPicture}.t < 0.150 ),channels(iCh)));
           y(iCh) = min(d{iSubject}.erp{iPicture}.zscore( find( d{iSubject}.erp{iPicture}.t > 0.100 & d{iSubject}.erp{iPicture}.t < 0.300 ),channels(iCh)));
           z(iCh) = min(d{iSubject}.erp{iPicture}.zscore( find( d{iSubject}.erp{iPicture}.t > 0.350 & d{iSubject}.erp{iPicture}.t < 0.550 ),channels(iCh)));

           
        end
        
        
           trainingSet = [ trainingSet [iPicture x y z]' ];
           trainingSet = trainingSet(:,randperm(size(trainingSet,2)));
           
           
           scatter3(x,y,z,pictureColor{iPicture});
   
    end    
        
 end
 
 hold off;
       
trainingInputs = trainingSet(2:end,1:length(trainingSet)*ratio);
testInputs = trainingSet(2:end, length(trainingSet)*ratio+1:end);
trainingTargets = trainingSet(1, 1:length(trainingSet)*ratio);
testTargets = trainingSet(1, length(trainingSet)*ratio+1:end);

testFace = [];
for k = 1:length(trainingSet)
    if trainingSet(1,k) == 1
        testFace = [testFace trainingSet(:,k)];
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


end

% plot( d{1}.erp{1}.data( find( d{1}.erp{1}.t > 0.100 & d{1}.erp{1}.t < 0.250 )) )