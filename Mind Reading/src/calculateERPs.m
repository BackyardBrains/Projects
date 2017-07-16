function [ s ] = calculateERPs( s )
%PLOTSESSIONAVERAGE Summary of this function goes here
%   Detailed explanation goes here
    
    removeMean = 1;
    timeWindow = [-0.5 0.5];
    
    t = s;
    %s = s{1};
    
    %getEEG average for face
    pictureTypes = {'faceOn' 'houseOn' 'sceneryOn' 'weirdOn'};
    
    for iType = 1:length(pictureTypes)
        rawERPEEGForOneImage = [];
        counterForERPs = 1;
        for iSegment = 1:length(s.timestamps.segmentBegin)
        
           % eval(['ts = s.timestamps.' pictureTypes{iType} ';']);
            eval(['ts = s.timestamps.' pictureTypes{iType} '( s.timestamps.' pictureTypes{iType} ' > s.timestamps.segmentBegin(iSegment) & s.timestamps.' pictureTypes{iType} ' <= s.timestamps.segmentEnd(iSegment) );']);
            for iPicture = 1:length(ts)

                tStart = round((ts(iPicture) + timeWindow(1)) *s.fs);
                tEnd = tStart + round((timeWindow(2)-timeWindow(1)) * s.fs);

                %get raw erp responses with removed mean
                m = mean(s.eeg(tStart:tEnd,:),1);
                mMat = repmat(m, [size(s.eeg(tStart:tEnd,:),1),1]);
                rawERPEEGForOneImage(counterForERPs,:,:) =  s.eeg( tStart : tEnd, : ) - mMat; 
                counterForERPs = counterForERPs+1;
             
                e(iSegment, iPicture, :, :) = s.eeg( tStart : tEnd, : );
                


                s.erp{iType }.segment{iSegment}.raw = squeeze(mean(e(iSegment,:,:,:)));
                s.erp{iType }.segment{iSegment}.n = length(ts);
                
                %Make zscore just on the EEG data in this segment.
                s.erp{iType }.segment{iSegment}.zscore = bsxfun(@minus, s.erp{iType}.segment{iSegment}.raw, mean(s.eeg( s.t >= s.timestamps.segmentBegin(iSegment) & s.t < s.timestamps.segmentEnd(iSegment), : )));
                s.erp{iType }.segment{iSegment}.zscore = bsxfun(@rdivide, s.erp{iType}.segment{iSegment}.zscore, std(s.eeg( s.t >= s.timestamps.segmentBegin(iSegment) & s.t < s.timestamps.segmentEnd(iSegment), : )));
        
            end
        
        end
        
        s.erp{iType }.rawEEG = rawERPEEGForOneImage;
        
        %Calcualte the session averages
        s.erp{iType }.raw = squeeze(mean(squeeze(mean(e))));
        s.erp{iType }.zscore = bsxfun(@minus, s.erp{iType}.raw, mean(s.eeg));
        s.erp{iType }.zscore = bsxfun(@rdivide, s.erp{iType }.zscore, std(s.eeg));
        

        
        s.erp{iType }.t = linspace(  timeWindow(1),  timeWindow(2), size(  s.erp{iType }.raw, 1 ));
        eval(['s.erp{iType}.name = ''' pictureTypes{iType} ''';']);
    end
    

end

