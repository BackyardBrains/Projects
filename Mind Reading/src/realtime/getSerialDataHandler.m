function [ out ] = getSerialDataHandler(varargin)
        %sampling freq EEG 1666Hz

        serialEEG = varargin{1};
        global dataEEG;
        global t;
        global initialTimer;
        global EEGMatrix;
        global lastProcessedIndex;
        
        global indexesOfImage;
        global erps;
        global erpsCounter;
        global classOfImage;
        global b;
        global a;
        global zi;
        %global graphic;
        global p;
        global roi;
        
        
        numberOfSeconds = 60*8.2;
        % numberOfSeconds = 60*8.5;
        fs = 1666;
        endOfRecording = numberOfSeconds * fs * 12;

        twoFs = 2*fs;
        maxEncodingLength = ceil(0.8*fs);

 

        
        
        if serialEEG.BytesAvailable > 0
            %disp('0');
            %disp(serialEEG.BytesAvailable/12);
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
                       
                        [resulteegMatrix,zi] = filter(b,a,double(resulteegMatrix),zi,2);
                        EEGMatrix = [EEGMatrix resulteegMatrix];
                        
                        
                        %Extract ERP if detected on 6th channel
                        
                        lengthOfEEG = size(EEGMatrix,2);
                        startSearchForERP = lengthOfEEG - size(resulteegMatrix,2)-6*fs;
                        if(startSearchForERP<1)
                            startSearchForERP = 1;
                        end
                         if(lengthOfEEG>(twoFs))
        
                            encoding = double(EEGMatrix(6,startSearchForERP:end));
                            threhsold = 0.5*(min(encoding) + max(encoding));

                            allPositions = find((diff(encoding<threhsold)>0.5));
                            allPositions = allPositions+startSearchForERP-1;
                            allPositions = allPositions(find(diff(allPositions)>maxEncodingLength)+1);
                            allPositions((allPositions+fs)>lengthOfEEG) = [];
                            if(length(indexesOfImage)>0)
                                allPositions(allPositions<=indexesOfImage(end)) = [];
                            end
                            for j=1:length(allPositions)
                                    roiEEG = double(EEGMatrix(1:5,allPositions(j)+roi(1):allPositions(j)+roi(2))');
                                    encodingChannel = double(EEGMatrix(6,allPositions(j)-100:allPositions(j)+fs));
                                    logicalEncoding = (diff((double(encodingChannel)<0.5*(max(double(encodingChannel))+min(double(encodingChannel)))))>0 );
                                    
                                    classOfImage = [classOfImage (sum(logicalEncoding)-1)];
                                    m = mean(roiEEG,1);
                                    mMat = repmat(m, [size(roiEEG,1),1]);
                                    roiEEG = roiEEG - mMat; 


                                erps(erpsCounter,:,:) = roiEEG;
                                erpsCounter = erpsCounter+1;
                                
                                
                                
                                set( p.h( p.eeg(1)), 'ydata', roiEEG(:,1)');
                                set( p.h( p.eeg(2)), 'ydata', roiEEG(:,2)');
                                set( p.h( p.eeg(3)), 'ydata', roiEEG(:,3)');
                                set( p.h( p.eeg(4)), 'ydata', roiEEG(:,4)');
                                set( p.h( p.eeg(5)), 'ydata', roiEEG(:,5)');
                                set( p.h( p.eeg(6)), 'ydata', encodingChannel);
                                

                                
                            end
                            indexesOfImage  = [indexesOfImage allPositions];
                        end

                        lastProcessedIndex = lastProcessedIndex+ endOfProcessingBlock;
                       
            end
            if(length(dataEEG)>endOfRecording)
                fclose(serialEEG);

                
                stop(t)
                EEGMatrixN = (int16(EEGMatrix) -512)*30;
                FileNameWav=['trainingRT-',datestr(now, 'dd-mmm-yyyy-HH-MM-SS'),'.wav'];
                audiowrite(FileNameWav,EEGMatrixN',1666);
                
                FileName=['trainingRT-',datestr(now, 'dd-mmm-yyyy-HH-MM-SS'),'.mat'];

                save(FileName,'classOfImage', 'EEGMatrix', 'erps');
                %figure;
                %plot(EEGMatrix')
                %title('Raw EEG data (Training)')

                %figure;
                subplot(  p.h( p.erp(1) ));
                faceAverage = squeeze(mean(erps(classOfImage==1,:,:),1));
                plot(faceAverage);
                %title('Face ERP (Training)');
                
                subplot(  p.h( p.erp(2) ));
                class2Aver = squeeze(mean(erps(classOfImage==2,:,:),1));
                plot(class2Aver);
                %title('House ERP (Training)');
                
                subplot(  p.h( p.erp(3) ));
                class3Aver = squeeze(mean(erps(classOfImage==3,:,:),1));
                plot(class3Aver);
                %title('Nature ERP (Training)');

                subplot(  p.h( p.erp(4) ));
                class4Aver = squeeze(mean(erps(classOfImage==4,:,:),1));
                plot(class4Aver);
                %title('Weird ERP (Training)');
                

                clear serialEMG
                clear t;
                startClassifier( erps, classOfImage );
            end
        end
        initialTimer =initialTimer+1;
       
        if(initialTimer<30)
            dataEEG = [];
            lastProcessedIndex = 1;
            EEGMatrix = [];
        end
end