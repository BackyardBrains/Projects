function [ out ] = plotPrePost( d, varargin )
%PLOTPREPOST will plot the pre- and post- treatment differences from an EEG
%sleep exeriment

barColor = 'b';
makeplot = 1;
errorbarColor = 'r';
typeOfPlot = 2;
for iarg= 1:2:(nargin-2),   % assume an even number of varargs

        switch lower(varargin{iarg}),

            case {'color','barcolor'}
                barColor = varargin{iarg+1};
            case 'type',
                typeOfPlot = varargin{iarg+1};

            case {'errorcolor','errorbarcolor'}
                errorbarColor = varargin{iarg+1};

            case 'plot',
                makeplot = varargin{iarg+1};

        end % end of switch
end % end of for iarg


allCuedImages = (d.treatment.cuedTargetIDs);
allUnCuedImages = (d.treatment.uncuedTargetIDs);

numOfCuedImages = length(allCuedImages);
numOfUnCuedImages = length(allUnCuedImages);

trialsForPreNapNoFeedback = d.testing{3}.trials;
numOfPreTrials = length(trialsForPreNapNoFeedback);

trialsForPostNapNoFeedback = d.testing{4}.trials;
numOfPostTrials = length(trialsForPostNapNoFeedback);

out.cuedBS = [];
out.cuedAS = [];
out.unCuedBS = [];
out.unCuedAS = [];

for t = 1:numOfPreTrials
    preIDs = trialsForPreNapNoFeedback{t}.targetID;
    if(sum(allCuedImages==preIDs)>0)
        out.cuedBS = [out.cuedBS trialsForPreNapNoFeedback{t}.distanceInPoints];
        
    else
        out.unCuedBS = [out.unCuedBS trialsForPreNapNoFeedback{t}.distanceInPoints];
    end   
end

for i = 1:numOfPostTrials
    postIDs = trialsForPostNapNoFeedback{i}.targetID;
    if(sum(allCuedImages==postIDs)>0)
        out.cuedAS = [out.cuedAS trialsForPostNapNoFeedback{i}.distanceInPoints];
        
    else
        out.unCuedAS = [out.unCuedAS trialsForPostNapNoFeedback{i}.distanceInPoints];
    end   
end

out.meanCuedBS = mean(out.cuedBS);
out.stdCuedBS = (std(out.cuedBS))/sqrt(24);
out.meanCuedAS = mean(out.cuedAS);
out.stdCuedAS = (std(out.cuedAS))/sqrt(24);
out.meanUnCuedBS = mean(out.unCuedBS);
out.stdUnCuedBS = (std(out.unCuedBS))/sqrt(24);
out.meanUnCuedAS = mean(out.unCuedAS);
out.stdUnCuedAS = (std(out.unCuedAS))/sqrt(24);
out.meanCued = out.meanCuedAS - out.meanCuedBS;
out.stdCued = out.stdCuedAS - out.stdCuedBS;
%out.stdCued = (std(out.meanCued))/sqrt(24);
out.meanUnCued = out.meanUnCuedAS - out.meanUnCuedBS;
out.stdUncued = out.stdUnCuedAS - out.stdUnCuedBS;
%out.stdUncued = (std(out.meanUnCued))/sqrt(24);

if makeplot
    
    if(typeOfPlot ==1)
        yDiff = [out.meanCued out.meanUnCued];
        stdErrorDiff = [out.stdCued out.stdUncued];
        %display(stdErrorDiff)
        bar(yDiff,0.3)
        set(gca,'XTickLabel',{'Cued','UnCued'})
     hold on;
     h=errorbar(yDiff,stdErrorDiff,'r'); set(h,'linestyle','none');

    else
        yAll =[out.meanCuedBS out.meanCuedAS out.meanUnCuedBS out.meanUnCuedAS];
        stdErrorAll = [out.stdCuedBS out.stdCuedAS out.stdUnCuedBS out.stdUnCuedAS];
        bar(yAll,0.3)
        set(gca,'XTickLabel',{'CuedBS','CuedAS','UnCuedBS','UnCuedAS'})
     hold on;
     h=errorbar(yAll,stdErrorAll,'r'); set(h,'linestyle','none');
    end

end

