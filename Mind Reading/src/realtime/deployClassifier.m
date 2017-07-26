function deployClassifier()

    if exist('serialEEG','var')
        fclose(serialEEG);
    end
    %clear;
    
    if ismac
        serialEEG = serial('/dev/cu.usbmodem1411', 'BaudRate', 921600);
    elseif isunix
    	serialEEG = serial('/dev/cu.usbmodem1411', 'BaudRate', 921600);
    else ispc
    	serialEEG = serial('COM21', 'BaudRate', 2000000);
    end
   

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

    
    global weirdimage;
    global houseimage;
    global faceimage;
    global sceneryimage;
    
    weirdimage = imread('Weird.jpg');
    houseimage = imread('House.jpg');
    faceimage = imread('Face.jpg');
    sceneryimage = imread('Scenery.jpg');
    
    
    global p;

    
    fs = 1666;
    fc = 60;
    
    clear top;
    top.sp = [2 1];
    top.h = [.5 .5];
    top.c(1).sp = [1 2]; 
    top.c(1).w = [0.25 0.75];
    top.c(2).sp = [1 2];
    top.c(2).w = [0.5 0.5];
    top.c(1).c(2).sp = [5 1];
   
    roiTime = [-0.1, 0.5];
    roi = ceil(roiTime*fs);    
 
    %make portable position handles
    p = [];
    p.image               = 1;
    p.eeg                 = 2:6;
    p.svmData             = 7;
    p.predictedImage      = 8;
    p.h = subsubplot(top);
    p.colors = {'g', 'y', 'c', [1 0 1], 'r', [1 0.375 0]};
    p.lineWidth = 2;
    p.timeForGraph = linspace(roiTime(1),roiTime(2),-roi(1)+roi(2)+1);
   
     
    for iPlot = 1:5
        subplot(  p.h( p.eeg(iPlot) ));
        p.h( p.eeg(iPlot) ) = plot(p.timeForGraph, ones(1,length(p.timeForGraph)));
        prettyPlots( p.h( p.eeg(iPlot) ), p.colors{iPlot} );
    end
     
    testingimg = imread('testing.jpg');
    subplot( p.h( p.image ) );
    p.h( p.image ) = image(testingimg);
    p.h( p.image ) = get(gca,'Children');
    
    
 
    notextimage = imread('notextimage.jpg');
    subplot( p.h( p.predictedImage ) );
    image(notextimage);
    p.h( p.predictedImage ) = get(gca,'Children');

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
    
end

function prettyPlots( pp, c )
    global p;

    set( gca, 'Color', 'k' );
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    set( pp, 'Color', c);
   set( pp, 'LineWidth', p.lineWidth );
   
    
end