function [ output_args ] = plotSessionAverage( s )
%PLOTSESSIONAVERAGE Summary of this function goes here
%   Detailed explanation goes here

    timeWindow = [-0.5 0.5];
    
    t = s;
    s = s{1};
    
    %getEEG average for face
    
    for iPicture = 1:length(s.timestamps.faceOn)
        
        tStart = round((s.timestamps.faceOn(iPicture) + timeWindow(1)) *s.fs);
        tEnd = tStart + round((timeWindow(2)-timeWindow(1)) * s.fs);
        
        %disp(tEnd - tStart);
        e(iPicture, :, :) = s.eeg( tStart : tEnd, : );
        
    end
    
    
    %--------- monte carlo ----------------------------
avrMCResults = [];
lengthOfEEG = length(s.eeg(:,1));
for ii = 1:100
    intervals = [];
    tempIndex = 0;
    for jj = 1:150
           indOf1 = round(rand*(lengthOfEEG-2002)+1001);
           tempIndex = tempIndex+1;
           intervals(:,:,tempIndex) = s.eeg(indOf1-1000:indOf1+1000,1:5);
           
    end
    intervals2 = sum(intervals, 3)./tempIndex;
    avrMCResults(:,:,ii) = intervals2;
    %plot(allTime,avrMCResults(:,:,ii));
    %pause;

end
stdMC = std(avrMCResults,0,3);

%__Plot_________________________________________________________________
    
        f = mean(e);
        g = size(f);
        h = g(2:3);
        i = reshape(f, h);
        temp = 0:(1/555):1;
        tempx = temp*1000-500;
        
         
        numrow = size(i, 1);
        j = i - repmat(mean(i), numrow, 1);
       
        j(:,1) = -  j(:,1);
        j(:,5) = -  j(:,5);
        
        figure;
        hold on;
        plot(tempx, j(:,1)/mean(stdMC(:,1)), 'g'); 
        plot(tempx, j(:,2)/mean(stdMC(:,2)), 'y'); 
        plot(tempx, j(:,3)/mean(stdMC(:,3)), 'b'); 
        plot(tempx, j(:,4)/mean(stdMC(:,4)), 'r');
        plot(tempx, j(:,5)/mean(stdMC(:,5)), 'k'); 
        
        title('Face')
        hold off;
       

end

