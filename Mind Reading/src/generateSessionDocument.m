function [ out ] = generateSessionDocument( d, varargin )
%generateSessionDocument Creates an overview of analysis routines
%   Can be used by one cell in the database or many.
%
%   generateSessionDocument( s, 'save', 0, 'pause', 1, 'close', 1);
%   generateSessionDocument( s, 'save', 1, 'pause', 0, 'close', 0);
%

pauseProgram = 0;
saveImage = 1;
closeImage = 1;

for iarg= 1:2:(nargin-1),   % assume an even number of varargs

    switch lower(varargin{iarg}),
  
        
	case {'time','t', 'timewindow' }
            timeWindow = varargin{iarg+1};

    case 'pause',
        pauseProgram = varargin{iarg+1};            
                            
    case 'save',
        saveImage = varargin{iarg+1};            
                            
    case 'close',
        closeImage = varargin{iarg+1};            
                    
    end % end of switch
end % end of for iarg

FILECREATED = 0;

%% Deterimine Window Heights
% explicitly set each subplot, with no other options
clear top;
top.sp = [2 1];
top.h = [.25 .75];
top.c(1).sp = [1 2]; 
top.c(1).w = [0.25 0.75];
top.c(1).c(2).sp = [5 1];
top.c(2).sp = [1 4];
top.c(2).w = [0.25 0.25 0.25 0.25];
top.c(2).c(1).sp=[4 1];
top.c(2).c(2).sp=[5 1];
%subsubplot_showlayout(top); 

%make portable position handles
p.info          = 1;
p.eeg           = 2:6;
p.erpPic        = 7:10;
p.erpCh         = 11:15;
p.notYet = 16:17;


color.pic = {[154 38 23]/255 [194 87 26]/255 [188 161 54]/255 [130 147 86]/255};
color.ch = { [1 0 0] [0 0 1] [0 0 0] [1 0.5 0.5] [0.5 0.5 0.5]};

for iSession = 1:size(d,2)
      
    figure;    
    h = subsubplot(top);
    %fillscreen( gcf );
    set( gcf, 'PaperOrientation', 'landscape' );
    set( gcf, 'PaperPosition', [0.1 0.1 10.8 8.3] );
    set( gcf, 'Position', [680 154 1145 880] );

    subplot( h(p.info ) );
    set( gca, 'YTickLabel', {} );
    set( gca, 'XTickLabel', {} );
    Ylim = get( gca, 'ylim' ); minY = Ylim(1); maxY = Ylim(2);
    ff = text( .1, 0.9 * range(Ylim) +  minY  , ['Subject: ' d{iSession}.subject ], 'FontName', 'Helvetica', 'FontSize', 11, 'FontWeight', 'bold' );
    ff = text( .1, 0.8 * range(Ylim) +  minY  , ['Total Time: ' num2str(floor(d{iSession}.t(end)/60)) 'm ' num2str(round(rem(d{iSession}.t(end),60))) 's' ], 'FontName', 'Helvetica', 'FontSize', 9, 'FontWeight', 'normal' );
    
    szLoc = ''; for i=1:length(d{iSession}.eegLocations) szLoc = [szLoc num2str(i) '=' d{iSession}.eegLocations{i} ' ']; end
    ff = text( .1, 0.7 * range(Ylim) +  minY  , ['EEG Locations: ' szLoc ], 'FontName', 'Helvetica', 'FontSize', 8, 'FontWeight', 'normal' );
    
    textPos = [0.6 0.5 0.4 0.3];
    for iERP = 1:size(d{iSession}.erp,2)
        maxBin = bsxfun(@eq, abs(d{iSession}.erp{iERP}.zscoreERP), max(abs(d{iSession}.erp{iERP}.zscoreERP)));
        maxZscore = d{iSession}.erp{iERP}.zscoreERP(maxBin);
        bestChannel = find(max(abs(maxZscore))==abs(maxZscore));
    
        ff = text( .1, textPos(iERP) * range(Ylim) +  minY, sprintf('High ERP %s Ch=[1], Z= [%2.3f], t=[%2.2fs]\n',d{iSession}.erp{iERP}.name(1:end-2),maxZscore( bestChannel ), d{iSession}.erp{iERP}.t(maxZscore(bestChannel) == d{iSession}.erp{iERP}.zscoreERP(:,bestChannel))), 'FontName', 'Helvetica', 'FontSize', 8, 'FontWeight', 'normal' );
    end
    
    
    %Loop by Channel
    for iCh = 1:size(d{iSession}.eeg,2)
        
        %Show the raw EEG for each Channel
        subplot( h(p.eeg(iCh)) );
        plot( d{iSession}.t,  d{iSession}.eeg(:,iCh), 'k' );
        xlim( [0 max(d{iSession}.t)] );
        ylim( [-0.03 0.03]); %Could make dynamic...
        Ylim = get( gca, 'ylim' ); minY = Ylim(1); maxY = Ylim(2);
        ff = text( 20, 0.9 * range(Ylim) +  minY  , ['Channel ' num2str(iCh) ' (' d{iSession}.eegLocations{iCh} ')' ], 'FontName', 'Helvetica', 'FontSize', 11, 'FontWeight', 'bold', 'color', color.ch{ iCh } );
        
        %vline( d{iSession}.timestamps.faceOn, 'r' );
        %vline( d{iSession}.timestamps.houseOn, 'b' );
        %vline( d{iSession}.timestamps.sceneryOn, 'g' );
        %vline( d{iSession}.timestamps.weirdOn, 'y' );
        cleanUpLabels( h(p.eeg(iCh)) );
        
        %Show the various ERPs for each Channel
        subplot( h(p.erpCh(iCh)) );
        hold on;
        %By Looping through the pictures.
        for iPic = 1:4
            plot( d{iSession}.erp{iPic}.t, d{iSession}.erp{iPic}.zscoreERP(:,iCh), 'color', color.pic{iPic} );
        end
        ylim([-1.5 1.5]);
        Ylim = get( gca, 'ylim' ); minY = Ylim(1); maxY = Ylim(2);
        ff = text( -0.45, 0.9 * range(Ylim) +  minY  , ['Channel ' num2str(iCh) ' (' d{iSession}.eegLocations{iCh} ')' ], 'FontName', 'Helvetica', 'FontSize', 11, 'FontWeight', 'bold', 'color', color.ch{ iCh } );
        cleanUpLabels( h(p.erpCh(iCh)) );
        hold off;
    end
    
    %Now Loop by Picture
    for iPic = 1:size(d{iSession}.erp,2)
        subplot( h(p.erpPic(iPic)) );
        hold on;
        %Then Show by Channel ERPs
        for iCh = 1:size(d{iSession}.eeg,2)
            plot( d{iSession}.erp{iPic}.t, d{iSession}.erp{iPic}.zscoreERP(:,iCh), 'color', color.ch{iCh} );
        end
        Ylim = get( gca, 'ylim' ); minY = Ylim(1); maxY = Ylim(2);
        ff = text( -0.45, 0.9 * range(Ylim) +  minY  , ['Picture [' d{iSession}.erp{iPic}.name(1:end-2) ']' ], 'FontName', 'Helvetica', 'FontSize', 11, 'FontWeight', 'bold', 'color', color.pic{ iPic } );
   
        hold off;
        cleanUpLabels( h(p.erpPic(iPic)) );
    end
    
    for hno = p.notYet
        cleanUpLabels( h(hno) );
    end
    
    if saveImage 
        
        if FILECREATED == 0
            filename = ['sessionDB-' date];
            print('-dpsc2', [filename '.ps']);
            closeImage = 1;
            pauseProgram = 0;
            FILECREATED = 1;
        else
            print('-dpsc2', [filename '.ps'], '-append');
        end
    end
   
    if pauseProgram
        pause
    end

    if closeImage
        close( gcf );
    end
    
end
end


function cleanUpLabels( ax )

    axes( ax );
    xlabel('');
    ylabel('');
    title('');
    set( gca, 'YTickLabel', {} );
    set( gca, 'XTickLabel', {} );
    
    %l = vline(0,'k-');
    %set( l, 'color', [0.5 0.5 0.5]);
    
end
function cleanUpHistograms( ax )

    axes( ax );
    xlabel('');
    ylabel('');
    title('');
    vline(0,'k--');
    
end
