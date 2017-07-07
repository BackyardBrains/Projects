
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
[processedSubsampledResultSB, processedLowFreqPSB,newDatumSB] = spectralDecomposition(eegdata, f1);
[trainedClassifier, validationAccuracy] = svm(newDatumSB);
[Accuracy1000, Accuracy500]  = runClassifier(trainedClassifier, processedLowFreqPSB, processedSubsampledResultSB);
Accuracy1000
Accuracy500