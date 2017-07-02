function [allInOneGraphPairs] = plotDistribOfFreqPairs(fm, fs, center, color, name)


fmy =fft(fm);
L=length(fm);
L2=round(L/2);
fa=abs(fmy(1:L2)); % half is essential, rest is aliasing
fmax=fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies


s2 = spectrogram(fm, 20000, [], [], fs, 'yaxis');
a2 = abs(s2);
numberOfSpectrums = size(a2,2);
allPeaks = [];
numberOfElementsToAnnulate = 100;
allInOneGraph = zeros(size(a2));
for i = 1:numberOfSpectrums
    
    peaks = [];
    peaksIndex = 0;
    while(peaksIndex<3) % number of peaks being analyzed and plotted
        [tempm, tempf] = max(a2(:,i));
        
        leftSide = tempf-numberOfElementsToAnnulate;
        if(leftSide<1)
            leftSide = 1;
        end
        rightSide  = tempf+numberOfElementsToAnnulate;
        if(rightSide>length(a2(:,i)))
            rightSide = length(a2(:,i));
        end
        a2(leftSide:rightSide, i) = zeros(rightSide-leftSide+1,1);
        if(tempf<230)
            continue;
        end
        peaksIndex = peaksIndex+1;
        peaks = [peaks tempf];
        allInOneGraph(tempf,i) = 1;
    end
   
    allPeaks = [allPeaks; peaks];
    
end
temp = allPeaks(:);



fband = 20; % changes width of frequency band on graph
maxF = 2000; % y limit
x=fband:fband:maxF;
h = hist(temp,x);
h = h/sum(h);
h(end) = 0;
hold on;
set(gca,'XTick',[]);
set(gca,'YTick',0:100:maxF)
for i = 1:length(x)
    plot([center-h(i) center+h(i)],[x(i) x(i)],'LineWidth',4,'color',color);	
end
text(center,100,name,'Color',color,'FontSize',18, 'HorizontalAlignment', 'center')
title('Frequency Distribution: Male & Female');
hold off;