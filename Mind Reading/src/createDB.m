function s = createDB(varargin)

TargetDir = '../data';

for iarg= 1:2:(nargin-1),   % assume an even number of varargs
 
    switch lower(varargin{iarg}),

        case {'dir','path','filepath'}
            TargetDir = varargin{iarg+1};

        case ''

        otherwise,

    end % end of switch
end % end of for iarg

subdirs = dir(TargetDir);
isitasubdir = [subdirs.isdir ];
datadirs = subdirs( isitasubdir );
subdirs = datadirs( 3:end ); %Remove all the weird . directories

s = {};
for iSession = 1:size( subdirs, 1 )
        
        d.subject = subdirs(iSession).name;
        d.date = subdirs(iSession).date;
        d.datenum = subdirs(iSession).datenum;
        
        disp(['Analyzing ' subdirs(iSession).name ]);
        
        datafilepath = [TargetDir '/' subdirs(iSession).name '/'];
        wavfiles = dir([datafilepath '*.wav']);
       
        rawData = [];
        currentSegmentBeginTime = 0;
        segmentTimes = [currentSegmentBeginTime];
        for iWavs = 1:size( wavfiles, 1 )
            [y, d.fs] = audioread([datafilepath '/' wavfiles(iWavs).name]);
            currentSegmentBeginTime = currentSegmentBeginTime + size(y,1) / d.fs;
            segmentTimes = [segmentTimes currentSegmentBeginTime];
            rawData = [rawData; y];
        end
        
        d.eeg = rawData(:,1:5);
        
        switch d.subject
            case 'MR03'
                d.eeg(:,2) = - d.eeg(:,2);
                d.eeg(:,4) = - d.eeg(:,4);
            case {'MR04', 'MR05'}
                d.eeg(:,1) = - d.eeg(:,1);
                d.eeg(:,5) = - d.eeg(:,5);
        end
        
        d.t = linspace( 0,size( rawData ,1  )/d.fs, size( rawData ,1  )); 
        d.eegLocations = {'P7', 'P8', 'C5', 'C6', 'CPz' };
        
        
        f1 = diff(rawData(:, 6))<0.5*min(diff(rawData(:, 6)));
        inside = 0;
        result = zeros(1,length(f1));

        indexOfLast = 0;
        for i=1:length(f1)
            if(inside>0)
                if(f1(i-1)==1 && f1(i)==0)
                    result(indexOfLast) = result(indexOfLast) +1;
                end
                inside = inside +1;
                if(inside >3000)
                    inside = 0;
                end
            end
            if(f1(i)==1)

                if(inside == 0)
                    inside = inside +1;
                    result(i) = 1;
                    indexOfLast = i;
                end
            end

        end
        result = result - 2;
        result(result==-2) = 0;

        d.timestamps.faceOn = d.t(find( result == 1 ));
        d.timestamps.houseOn = d.t(find( result == 2 ));
        d.timestamps.sceneryOn = d.t(find( result == 3 ));
        d.timestamps.weirdOn = d.t(find( result == 4 ));
        d.timestamps.segmentBegin = segmentTimes( 1 : end -1);
        d.timestamps.segmentEnd = segmentTimes( 2 : end);
        %Here we can downsample d.eeg by 3
        %and change d.fs to d.fs/3.
        dsEEG = [];
        for iCh = 1:size( d.eeg, 2 )
           dsEEG(iCh,:) = decimate( d.eeg(:,iCh), 3 );
        end
        d.eeg = dsEEG';  
        
        d.fs = d.fs/3;
        d.t = linspace( 0,size( d.eeg ,1  )/d.fs, size( d.eeg ,1  )); 
        
        d = calculateERPs( d );
        s{iSession} = d;
        clear d;
    end   
 
end
        