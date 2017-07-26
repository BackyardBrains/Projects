function [ output_args ] = rtClassificationHandler(varargin)

        %sampling freq EEG 1666Hz

        serialEEG = varargin{1};
        global dataEEG;
        global timer2
        global initialTimer;
        global EEGMatrix;
        global lastProcessedIndex;
        
        global indexesOfImage;
        global erps;
        global erpsCounter;
        global corectClasses;
        global classifier;
        global predictedClasses;
        global b;
        global a;
        global zi;
        global roi;
        %global graphic;
        global p;
        
        global weirdimage;
        global houseimage;
        global faceimage;
        global sceneryimage;
        global correctimg;
        global incorrectimg;

        
        

        numberOfSeconds = 30;

        % numberOfSeconds = 60*6.25;
        fs = 1666;
        endOfRecording = numberOfSeconds * fs * 12;

        twoFs = 2*fs;
        maxEncodingLength = ceil(0.8*fs);
        roiTime = [-0.1, 0.5];
        roi = ceil(roiTime*fs);
 
 

 
        
        
        if serialEEG.BytesAvailable > 0
            %disp('0');
            
            dataEEG = [dataEEG; fread(serialEEG,serialEEG.BytesAvailable)];
            if(initialTimer>=30)
                %disp(length(dataEEG)/(12*1666));
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


                        eegMatrixp = newEEG(tempIndex)';
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+1)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+2)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+3)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+4)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+5)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+6)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+7)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+8)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+9)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+10)'];
                        eegMatrixp = [eegMatrixp; newEEG(tempIndex+11)'];

                        %find columns with invalid frames
                        moreThanOneFrame = find(sum((eegMatrixp>127))>1);
             
                        %replace columns that have invalid frame with adjacent columns
                        eegMatrixp(:,moreThanOneFrame) = eegMatrixp(:,moreThanOneFrame+1);

                        andedeegMatrix = uint16(bitand(uint8(eegMatrixp),127));

                        resulteegMatrix = [];
                        resulteegMatrix = andedeegMatrix(1,:).*128 + andedeegMatrix(2,:);
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(3,:).*128 + andedeegMatrix(4,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(5,:).*128 + andedeegMatrix(6,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(7,:).*128 + andedeegMatrix(8,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(9,:).*128 + andedeegMatrix(10,:)];
                        resulteegMatrix = [resulteegMatrix; andedeegMatrix(11,:).*128 + andedeegMatrix(12,:)];
                       
                        [resulteegMatrix,zi] = filter(b,a,double(resulteegMatrix),zi,2);
                        EEGMatrix = [EEGMatrix resulteegMatrix];
                        
                        
                        %Extract ERP if detected on 6th channel
                        
                        lengthOfEEG = size(EEGMatrix,2);
                        startSearchForERP = lengthOfEEG - size(resulteegMatrix,2)-6*fs;
                        if(startSearchForERP<1)
                            startSearchForERP = 1;
                        end
                         if(lengthOfEEG>(twoFs))
        
                                    lengthOfRoi = -roi(1)+roi(2);
                                    roiEEG = double(EEGMatrix(1:5,lengthOfEEG-lengthOfRoi:lengthOfEEG)');
                                    
                                    m = mean(roiEEG,1);
                                    mMat = repmat(m, [size(roiEEG,1),1]);
                                    roiEEG = roiEEG - mMat; 
                                    
                                    
                                    %create input vector
                                    inputVector = [roiEEG(:,1);roiEEG(:,2);roiEEG(:,4)]';
                                    
                                    set( p.h( p.eeg(1)), 'ydata', roiEEG(:,1)');
                                    set( p.h( p.eeg(2)), 'ydata', roiEEG(:,2)');
                                    set( p.h( p.eeg(3)), 'ydata', roiEEG(:,3)');
                                    set( p.h( p.eeg(4)), 'ydata', roiEEG(:,4)');
                                    set( p.h( p.eeg(5)), 'ydata', roiEEG(:,5)');
                                    
                                    
                                    
                                    %predict output for test data
                                    disp('------------------------------')
                                    disp('Decoding...')
                                    disp(length(dataEEG)/(12*1666));
                                    predictedOutputs = classifier.predictFcn(inputVector);
                                    predictedOutputs
                                    predictedClasses = [predictedClasses predictedOutputs];

                                    
                                    switch predictedOutputs
                                        case 1
                                            set(p.h( p.predictedImage ),'CData',faceimage);
                                        case 2
                                            set(p.h( p.predictedImage ),'CData',houseimage);
                                        case 3
                                            set(p.h( p.predictedImage ),'CData',sceneryimage);
                                        case 4
                                            set(p.h( p.predictedImage ),'CData',weirdimage);
                                    end
                                    pause(0.00000001);%added so that image starts drawing
                                    disp('------------------------------')

                                   
                       
                       
            end
            if(length(dataEEG)>endOfRecording)
                fclose(serialEEG);
                
                EEGMatrixN = (int16(EEGMatrix) -512)*30;
                FileNameWav=['resultsRT-',datestr(now, 'dd-mmm-yyyy-HH-MM-SS'),'.wav'];
                audiowrite(FileNameWav,EEGMatrixN',1666);
                
                FileName=['resultsRT-',datestr(now, 'dd-mmm-yyyy-HH-MM-SS'),'.mat'];
                save(FileName,'predictedClasses', 'EEGMatrix','classifier');
                stop(timer2)
                disp('End of decoding')
                disp('******************************');

                clear serialEMG
                clear timer2;
            end
        end
        initialTimer =initialTimer+1;
       
        if(initialTimer<30)
            dataEEG = [];
            lastProcessedIndex = 1;
            EEGMatrix = [];
        end

end