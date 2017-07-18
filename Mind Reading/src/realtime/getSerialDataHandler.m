function [ output_args ] = getSerialDataHandler(varargin)
        %sampling freq EEG 1666Hz

        serialEEG = varargin{1};
        global dataEEG;
        global t
        global initialTimer;
        global EEGMatrix;
        global lastProcessedIndex;
        
        global indexesOfImage;
        global erps;
        global erpsCounter;
        
        numberOfSeconds = 10;
        fs = 1666;
        endOfRecording = numberOfSeconds * fs * 12;

        twoFs = 2*fs;
        maxEncodingLength = ceil(0.8*fs);
        roiTime = [-0.5, 0.5];
        roi = ceil(roiTime*fs);
 
 

 
        
        
        if serialEEG.BytesAvailable > 0
            %disp('0');
            disp(serialEEG.BytesAvailable/12);
            dataEEG = [dataEEG; fread(serialEEG,serialEEG.BytesAvailable)];
            if(initialTimer>=30)
                disp(length(dataEEG)/(12*1666));
            end
            %parsing serial data into channels
            if(length(dataEEG)>lastProcessedIndex+13)
                
                        newEEG = dataEEG(lastProcessedIndex:end);
                        temp = newEEG>127;
                        tempIndex = find(temp);
                       
                        if(lastProcessedIndex~=(lastProcessedIndex+tempIndex(1)-1))
                            lastProcessedIndex = (lastProcessedIndex+tempIndex(1)-1);
                        end

                        endOfProcessingBlock = length(newEEG);
                        if((endOfProcessingBlock - tempIndex(end))<11)
                            
                            endOfProcessingBlock = tempIndex(end)-1;
                            tempIndex = tempIndex(1:end-1);
                        end


                        eegMatrix = newEEG(tempIndex)';
                        eegMatrix = [eegMatrix; newEEG(tempIndex+1)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+2)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+3)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+4)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+5)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+6)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+7)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+8)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+9)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+10)'];
                        eegMatrix = [eegMatrix; newEEG(tempIndex+11)'];

                        %find columns with invalid frames
                        moreThanOneFrame = find(sum((eegMatrix>127))>1);
             
                        %replace columns that have invalid frame with adjacent columns
                        eegMatrix(:,moreThanOneFrame) = eegMatrix(:,moreThanOneFrame+1);

                        andedeegMatrix = uint16(bitand(uint8(eegMatrix),127));

                        resulteegMatrix = [];
                        resulteegMatrix = andedeegMatrix(1,:).*128 + andedeegMatrix(2,:);
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(3,:).*128 + andedeegMatrix(4,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(5,:).*128 + andedeegMatrix(6,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(7,:).*128 + andedeegMatrix(8,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(9,:).*128 + andedeegMatrix(10,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(11,:).*128 + andedeegMatrix(12,:)];
                       
                        
                        EEGMatrix = [EEGMatrix resulteegMatrix];
                        
                        
                        %Extract ERP if detected on 6th channel
                        
                        lengthOfEEG = size(EEGMatrix,2);
                        startSearchForERP = lengthOfEEG - size(resulteegMatrix,2)-6*fs;
                        if(startSearchForERP<1)
                            startSearchForERP = 1;
                        end
                        if(lengthOfEEG>(twoFs))

                            encoding = double(EEGMatrix(6,startSearchForERP:end));
                            threhsold = 0.5*min(diff(encoding));
                            allPositions = find((diff(diff(encoding)<threhsold)>0.5));
                            allPositions = allPositions+startSearchForERP-1;
                            allPositions = allPositions(find(diff(allPositions)>maxEncodingLength)+1);
                            allPositions((allPositions+fs)>lengthOfEEG) = [];
                            if(length(indexesOfImage)>0)
                                allPositions(allPositions<=indexesOfImage(end)) = [];
                            end
                            for j=1:length(allPositions)
                                    roiEEG = double(EEGMatrix(:,allPositions(j)+roi(1):allPositions(j)+roi(2))');
                                    m = mean(roiEEG,1);
                                    mMat = repmat(m, [size(roiEEG,1),1]);
                                    roiEEG = roiEEG - mMat; 


                                erps(erpsCounter,:,:) = roiEEG;%EEGMatrix(:,allPositions(j)+roi(1):allPositions(j)+roi(2))' ;
                                erpsCounter = erpsCounter+1;
                            end
                            indexesOfImage  = [indexesOfImage allPositions];
                        
                        end

                        lastProcessedIndex = lastProcessedIndex+ endOfProcessingBlock;
                       
            end
            if(length(dataEEG)>endOfRecording)
                fclose(serialEEG);
                stop(t)
                figure;
                plot(EEGMatrix')
                title('Raw EEG data')
                figure;
                plot(mean(erps(:,:,1)));
                title('Mean ERP for first channel')
                clear serialEMG
                clear t;
            end
        end
        initialTimer =initialTimer+1;
       
        if(initialTimer<30)
            dataEEG = [];
            lastProcessedIndex = 1;
            EEGMatrix = [];
        end
end