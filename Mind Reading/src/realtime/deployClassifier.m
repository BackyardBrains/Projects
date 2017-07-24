    
if exist('serialEEG','var')
        fclose(serialEEG);
    end
    %clear;
    
    serialEEG = serial('/dev/cu.usbmodem1411', 'BaudRate', 921600);
    %serialEEG = serial('COM21', 'BaudRate', 2000000);    
   

    serialEEG.ReadAsyncMode = 'continuous';
    serialEEG.InputBufferSize = 140000;
    global dataEEG;
    global EEGMatrix;
    global initialTimer;
    global lastProcessedIndex;
    global indexesOfImage;
    global erps;
    global erpsCounter;
    global corectClasses;
    global predictedClasses;
    global b;
    global a;
    global zi;
    global roi;
    global graphic;
    global classifier;
    global roiTime;
    global p;
    
    testingimg = imread('testing.jpg');
    %subplot( p.h( p.image ) );
    set(p.h( p.image ),'CData',testingimg);
%     
%     figure;
%     subplot(1,3,1);
%     sizeOfInput = -roi(1)+roi(2)+1;
%     subplot(1,3,1);
%     plot(linspace(roiTime(1), roiTime(2),sizeOfInput),classifier.ClassificationSVM.Beta(1:sizeOfInput));
%     title('Wights of SVM for 1th channel')
%     subplot(1,3,2);
%     plot(linspace(roiTime(1), roiTime(2),sizeOfInput),classifier.ClassificationSVM.Beta(sizeOfInput+1:2*sizeOfInput));
%     title('Wights of SVM for 2nd channel')
%     subplot(1,3,3);
%     plot(linspace(roiTime(1), roiTime(2),sizeOfInput),classifier.ClassificationSVM.Beta(2*sizeOfInput+1:3*sizeOfInput));
%     title('Wights of SVM for 4th channel')
%     
    
    fs = 1666;
    fc = 60;
     [b,a] = butter(2,fc/(fs/2));
        zi = [];
    
    
    
    predictedClasses = [];
    corectClasses = [];
    indexesOfImage = [];
    erps = [];
    erpsCounter = 1;
    lastProcessedIndex =1;
    EEGMatrix = [];
    initialTimer = 0;
    dataEEG=[];
    fopen(serialEEG);
    
    global timer2
    timer2 = timer('TimerFcn', @(x,y)rtClassificationHandler(serialEEG, dataEEG), 'Period',  0.1);
    set(timer2,'ExecutionMode','fixedRate');
    disp('Start decoding')
    start(timer2);