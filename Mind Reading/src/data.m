function eegdata = data(a)

FileNameStr1 = '../data/Christy_1st.wav'; 
eegdata1 = audioread(FileNameStr1);
FileNameStr2 = '../data/Christy_2nd.wav'; 
eegdata2 = audioread(FileNameStr2);
FileNameStr3 = '../data/Christy_3rd.wav'; 
eegdata3 = audioread(FileNameStr3);
FileNameStr4 = '../data/Christy_4th.wav'; 
eegdata4 = audioread(FileNameStr4);
FileNameStr5 = '../data/Christy_5th.wav'; 
eegdata5 = audioread(FileNameStr5);

eegdataA = [eegdata1; eegdata2; eegdata3; eegdata4; eegdata5];
for k=1:5
   eegdataA(1:end, k) = (eegdataA(1:end, k) - mean(eegdataA(1:end, k)))/std(eegdataA(1:end, k));
end

FileNameStr6 = '../data/Spencer_1st.wav'; 
eegdata6 = audioread(FileNameStr6);
FileNameStr7 = '../data/Spencer_2nd.wav'; 
eegdata7 = audioread(FileNameStr7);
FileNameStr8 = '../data/Spencer_3rd.wav'; 
eegdata8 = audioread(FileNameStr8);
FileNameStr9 = '../data/Spencer_4th.wav'; 
eegdata9 = audioread(FileNameStr9);
FileNameStr10 = '../data/Spencer_5th.wav'; 
eegdata10 = audioread(FileNameStr10);

eegdataB = [eegdata6; eegdata7; eegdata8; eegdata9; eegdata10];
for k=1:5
   eegdataB(1:end, k) = (eegdataB(1:end, k) - mean(eegdataB(1:end, k)))/std(eegdataB(1:end, k));
end

FileNameStr11 = '../data/Ilya_1st.wav'; 
eegdata11 = audioread(FileNameStr11);
FileNameStr12 = '../data/Ilya_2nd.wav'; 
eegdata12 = audioread(FileNameStr12);
FileNameStr13 = '../data/Ilya_3rd.wav'; 
eegdata13 = audioread(FileNameStr13);
FileNameStr14 = '../data/Ilya_4th.wav'; 
eegdata14 = audioread(FileNameStr14);
FileNameStr15 = '../data/Ilya_5th.wav'; 
eegdata15 = audioread(FileNameStr15);

eegdataC = [eegdata11; eegdata12; eegdata13; eegdata14; eegdata15];
eegdataC(1:end, 2) = - eegdataC(1:end, 2);
for k=1:5
   eegdataC(1:end, k) = (eegdataC(1:end, k) - mean(eegdataC(1:end, k)))/std(eegdataC(1:end, k));
end

FileNameStr16 = '../data/Haley_1st.wav'; 
eegdata16 = audioread(FileNameStr16);
FileNameStr17 = '../data/Haley_2nd.wav'; 
eegdata17 = audioread(FileNameStr17);
FileNameStr18 = '../data/Haley_3rd.wav'; 
eegdata18 = audioread(FileNameStr18);
FileNameStr19 = '../data/Haley_4th.wav'; 
eegdata19 = audioread(FileNameStr19);
FileNameStr20 = '../data/Haley_5th.wav'; 
eegdata20 = audioread(FileNameStr20);

eegdataD = [eegdata16; eegdata17; eegdata18; eegdata19; eegdata20];
eegdataD(1:end, 4) = - eegdataD(1:end, 4);
for k=1:5
   eegdataD(1:end, k) = (eegdataD(1:end, k) - mean(eegdataD(1:end, k)))/std(eegdataD(1:end, k));
end

FileNameStr21 = '../data/Joud_1st.wav'; 
eegdata21 = audioread(FileNameStr21);
FileNameStr22 = '../data/Joud_2nd.wav'; 
eegdata22 = audioread(FileNameStr22);
FileNameStr23 = '../data/Joud_3rd.wav'; 
eegdata23 = audioread(FileNameStr23);
FileNameStr24 = '../data/Joud_4th.wav'; 
eegdata24 = audioread(FileNameStr24);
FileNameStr25 = '../data/Joud_5th.wav'; 
eegdata25 = audioread(FileNameStr25);

eegdataE = [eegdata21; eegdata22; eegdata23; eegdata24; eegdata25];
eegdataE(1:end, 1) = - eegdataE(1:end, 1);
eegdataE(1:end, 2) = eegdataE(1:end, 2);
eegdataE(1:end, 5) = - eegdataE(1:end, 5);
for k=1:5
   eegdataE(1:end, k) = (eegdataE(1:end, k) - mean(eegdataE(1:end, k)))/std(eegdataE(1:end, k));
end

FileNameStr26 = '../data/Shreya_1st.wav'; 
eegdata26 = audioread(FileNameStr26);
FileNameStr27 = '../data/Shreya_2nd.wav'; 
eegdata27 = audioread(FileNameStr27);
FileNameStr28 = '../data/Shreya_3rd.wav'; 
eegdata28 = audioread(FileNameStr28);
FileNameStr29 = '../data/Shreya_4th.wav'; 
eegdata29 = audioread(FileNameStr29);
FileNameStr30 = '../data/Shreya_5th.wav'; 
eegdata30 = audioread(FileNameStr30);

eegdataF = [eegdata26; eegdata27; eegdata28; eegdata29; eegdata30];
eegdataF(1:end, 1) = - eegdataF(1:end, 1);
eegdataF(1:end, 2) = eegdataF(1:end, 2);
eegdataF(1:end, 5) = - eegdataF(1:end, 5);
for k=1:5
   eegdataF(1:end, k) = (eegdataF(1:end, k) - mean(eegdataF(1:end, k)))/std(eegdataF(1:end, k));
end

if a == 2
    eegdata = [eegdataA; eegdataB; eegdataC; eegdataD; eegdataE; eegdataF];
elseif a == 1
    eegdata = [eegdataA];
end

end