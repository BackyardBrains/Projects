 clear;
 db = createDB();
subject = 2;%index of subject

trainingAndTestData = prepareSVMData(db{subject},subject);
trainedClassifier = classifyRawERP( trainingAndTestData );
