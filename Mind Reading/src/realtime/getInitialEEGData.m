  
    if exist('serialEEG','var')
        fclose(serialEEG);
    end
    serialEEG = serial('COM21', 'BaudRate', 2000000);    
   

    serialEEG.ReadAsyncMode = 'continuous';
    serialEEG.InputBufferSize = 80000;
    global dataEEG;
    global EEGMatrix;
    global initialTimer;
    global lastProcessedIndex;
    lastProcessedIndex =1;
    EEGMatrix = [];
    initialTimer = 0;
    dataEEG=[];
    fopen(serialEEG);
    
    global t
    t = timer('TimerFcn', @(x,y)getSerialDataHandler(serialEEG, dataEEG), 'Period',  0.1);
    set(t,'ExecutionMode','fixedRate');
    start(t);