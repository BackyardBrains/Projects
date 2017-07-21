  
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
    
    
    clear top;
    top.sp = [3 1];
    top.h = [.25 .75/2 .75/2];
    top.c(1).sp = [1 2]; 
    top.c(1).w = [0.25 0.75];
    top.c(2).sp = [1 2];
    top.c(2).w = [0.5 0.5];
    top.c(3).sp = [1 2];
    top.c(3).w = [0.5 0.5];
    top.c(1).c(2).sp = [6 1];
    %subsubplot_showlayout(top); 

    global p;
    %make portable position handles
    p.info          = 1;
    p.eeg           = 2:7;
    p.erpCh         = 8:11;
    p.h = subsubplot(top);
        
    
    global t
    t = timer('TimerFcn', @(x,y)getSerialDataHandler(serialEEG, dataEEG), 'Period',  0.1);
    set(t,'ExecutionMode','fixedRate');
    start(t);