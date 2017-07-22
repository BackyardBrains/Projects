  
    if exist('serialEEG','var')
        fclose(serialEEG);
    end
    %clear;
    
    %serialEEG = serial('/dev/cu.usbmodem1411', 'BaudRate', 921600);
     serialEEG = serial('COM21', 'BaudRate', 2000000);    
   

    serialEEG.ReadAsyncMode = 'continuous';
    serialEEG.InputBufferSize = 140000;
    global dataEEG;
    global EEGMatrix;
    global initialTimer;
    global lastProcessedIndex;
    global indexesOfImage;
    global erps;
    global erpsCounter;
    global classOfImage;
    global b;
    global a;
    global zi;
    global graphic;
    global roi;
    
    fs = 1666;
    fc = 100;
     [b,a] = butter(2,fc/(fs/2));
        zi = [];
    
    roiTime = [-0.1, 0.5];
    roi = ceil(roiTime*fs);    
    
    classOfImage = [];
    indexesOfImage = [];
    erps = [];
    erpsCounter = 1;
    lastProcessedIndex =1;
    EEGMatrix = [];
    initialTimer = 0;
    dataEEG=[];
    fopen(serialEEG);
    
 
    figure;
    graphic = [];
    graphic.ax11 = subplot(3,2,1);
    graphic.ax12 = subplot(3,2,2);
    graphic.ax21 = subplot(3,2,3);
    graphic.ax22 = subplot(3,2,4);
    graphic.ax31 = subplot(3,2,5);
    graphic.ax32 = subplot(3,2,6);

    graphic.timeForGraph = linspace(roiTime(1),roiTime(2),-roi(1)+roi(2)+1);
    %first iteration, create the graphics
    graphic.h11 = plot(graphic.ax11, graphic.timeForGraph, zeros(1,length(graphic.timeForGraph)));
    title(graphic.ax11, 'First channel');
    graphic.h12 = plot(graphic.ax12, graphic.timeForGraph, zeros(1,length(graphic.timeForGraph)));
    title(graphic.ax12, 'Second channel');       
    graphic.h21 = plot(graphic.ax21, graphic.timeForGraph, zeros(1,length(graphic.timeForGraph)));
    title(graphic.ax21, 'Third channel');
    graphic.h22 = plot(graphic.ax22, graphic.timeForGraph, zeros(1,length(graphic.timeForGraph)));
    title(graphic.ax22, 'Fourth channel'); 
    graphic.h31 = plot(graphic.ax31, graphic.timeForGraph, zeros(1,length(graphic.timeForGraph)));
    title(graphic.ax31, 'Fifth channel');
    graphic.h32 = plot(graphic.ax32, graphic.timeForGraph, zeros(1,length(graphic.timeForGraph)));
    title(graphic.ax32, 'Sixth channel');   
    
    
    figure;
    global faceimg;
    global sceneimg;
    faceimg = imread('face.jpg');
    sceneimg = imread('scene.jpg');
    trainingimg = imread('training.jpg');
    image(trainingimg);
    set(gca, 'XTick', []);
    set(gca, 'YTick', []);
    graphic.imageHandle = get(gca,'Children');

    
    
    
    
    
        
    
    global t
    t = timer('TimerFcn', @(x,y)getSerialDataHandler(serialEEG, dataEEG), 'Period',  0.1);
    set(t,'ExecutionMode','fixedRate');
    start(t);