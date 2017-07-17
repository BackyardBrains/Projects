function [ output_args ] = getSerialDataHandler(varargin)
        %sampling freq EEG 1666Hz

        serialEEG = varargin{1};
        global dataEEG;
        global t
        global initialTimer;
        global EEGMatrix;
        global lastProcessedIndex;
        
        numberOfSeconds = 60*15;
        fs = 1666;
        endOfRecording = numberOfSeconds * fs * 12;
        
    
        if serialEEG.BytesAvailable > 0
            %disp('0');
            %disp(serialEMG.BytesAvailable);
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

                        lastProcessedIndex = lastProcessedIndex+ endOfProcessingBlock;
                       
            end
            if(length(dataEEG)>endOfRecording)
                fclose(serialEEG);
                stop(t)
                plot(EEGMatrix')
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