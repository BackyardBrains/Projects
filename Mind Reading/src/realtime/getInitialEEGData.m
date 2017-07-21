  
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
    
    fs = 1666;
    fc = 100;
     [b,a] = butter(2,fc/(fs/2));
        zi = [];
    
    classOfImage = [];
    indexesOfImage = [];
    erps = [];
    erpsCounter = 1;
    lastProcessedIndex =1;
    EEGMatrix = [];
    initialTimer = 0;
    dataEEG=[];
    fopen(serialEEG);
    
    global t
    t = timer('TimerFcn', @(x,y)getSerialDataHandler(serialEEG, dataEEG), 'Period',  0.1);
    set(t,'ExecutionMode','fixedRate');
    start(t);