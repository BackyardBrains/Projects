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

        eval(['ts = s.timestamps.' pictureTypes{iType} ';']);
        
        for iPicture = 1:length(ts)

            tStart = round((ts(iPicture) + timeWindow(1)) *s.fs);
            tEnd = tStart + round((timeWindow(2)-timeWindow(1)) * s.fs);

            %if removeMean 
            %    m = mean(s.eeg(tStart:tEnd,:),1);
            %    mMat = repmat(m, [size(s.eeg(tStart:tEnd,:),1),1]);
            %    e(iPicture, :, :) = s.eeg( tStart : tEnd, : ) - mMat; 
            %else
            e(iPicture, :, :) = s.eeg( tStart : tEnd, : );
            %end
            
            
            
        end
        
        s.erp{iType }.raw = squeeze(mean(e));
        %s.erp{iType }.zscore = (s.erp{iType}.raw .- mean(s.eeg)') ./ std(s.eeg)';
        s.erp{iType }.zscore = bsxfun(@minus, s.erp{iType}.raw, mean(s.eeg));
        s.erp{iType }.zscore = bsxfun(@rdivide, s.erp{iType }.zscore, std(s.eeg));
        
        s.erp{iType }.t = linspace(  timeWindow(1),  timeWindow(2), size(  s.erp{iType }.raw, 1 ));
        eval(['s.erp{iType}.name = ''' pictureTypes{iType} ''';']);
    end
    

end

