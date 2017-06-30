% read all sound clips from recordings
[m1,fs] = audioread('AAM001-062017-01.wav');
[m2,fs2m] = audioread('AAM002-062117-02.wav');
[m3,fs3m] = audioread('AAM003-062117-02.wav');
[m4,fs4m] = audioread('AAM004-062117-02.wav');
[m5,fs5m] = audioread('AAM005-062117-02.wav');
[m6,fs6m] = audioread('AAM006-062117-03.wav');
[m7,fs7m] = audioread('AAM007-062117-03.wav');
[m8,fs8m] = audioread('AAM008-062117-03.wav');
[m9,fs9m] = audioread('AAM009-062117-03.wav');
[m11,fs11m] = audioread('AAM011-062717-06.wav');
[m12,fs12m] = audioread('AAM012-062717-06.wav');
[m13,fs13m] = audioread('AAM013-062717-06.wav');
[m14,fs14m] = audioread('AAM014-062717-06.wav');
[m16,fs16m] = audioread('AAM016-062717-06.wav');
[m17,fs17m] = audioread('AAM017-062717-06.wav');
[m18,fs18m] = audioread('AAM018-062717-06.wav');
[m19,fs19m] = audioread('AAM019-062717-06.wav');
[m20,fs20m] = audioread('AAM020-062717-06.wav');

[f1,fs1f] = audioread('AAF001-062017-01.wav');
[f2,fs2f] = audioread('AAF002-062117-03.wav');
[f3,fs3f] = audioread('AAF003-062117-03.wav');
[f4,fs4f] = audioread('AAF004-062117-03.wav');
[f5,fs5f] = audioread('AAF005-062217-004.wav');
[f8,fs8f] = audioread('AAF008-062217-04.wav');
[f13,fs13f] = audioread('AAF013-062217-04.wav');
[f14,fs14f] = audioread('AAF014-062717-06.wav');
[f20,fs20f] = audioread('AAF020-062717-06.wav');
[f22,fs22f] = audioread('AAF022-062717-06.wav');
[f23,fs23f] = audioread('AAF023-062717-06.wav');
[f24,fs24f] = audioread('AAF024-062717-06.wav');
[f25,fs25f] = audioread('AAF025-062717-06.wav');
[f26,fs26f] = audioread('AAF026-062717-06.wav');
[f27,fs27f] = audioread('AAF027-062717-06.wav');

% normalize by eliminating second column
m1 = m1(:,1);
m2 = m2(:,1);
m3 = m3(:,1);
m4 = m4(:,1);
m5 = m5(:,1);
m6 = m6(:,1);
m7 = m7(:,1);
m8 = m8(:,1);
m9 = m9(:,1);
m11 = m11(:,1);
m12 = m12(:,1);
m13 = m13(:,1);
m14 = m14(:,1);
m16 = m16(:,1);
m17 = m17(:,1);
m18 = m18(:,1);
m19 = m19(:,1);
m20 = m20(:,1);

f1 = f1(:,1);
f2 = f2(:,1);
f3 = f3(:,1);
f4 = f4(:,1);
f5 = f5(:,1);
f8 = f8(:,1);
f13 = f13(:,1);
f14 = f14(:,1);
f20 = f20(:,1);
f22 = f22(:,1);
f23 = f23(:,1);
f24 = f24(:,1);
f25 = f25(:,1);
f26 = f26(:,1);
f27 = f27(:,1);

% combine all recordings into one column 
m = [m1; m2; m3; m4; m5; m6; m7; m8; m9; m11; m12; m13; m14; m16; m17; m18; m19; m20]; % male recordings

f = [f1; f2; f3; f4; f5; f8; f13; f14; f20; f22; f23; f24; f25; f26; f27]; % female recordings

% plot frequency distribution
allPeaksM = plotDistribOfFreq(m, fs, -0.1, [0 0 1], 'Male');
hold on;
allPeaksF = plotDistribOfFreq(f,fs, 0.1, [255/255 105/255 180/255], 'Female');
hold off

%% plot spectrogram peaks only
% female
% allPeaksFS = image(allPeaksF*255);
% ylim([0 1800]);
% ylabel('Frequency (Hz)') % y-axis label
% title('Female Recordings: Spectrogram Peaks')

% male
% allPeaksMS = image(allPeaksM*255);
% ylim([0 2000]);
% ylabel('Frequency (Hz)') % y-axis label
% title('Male Recordings: Spectrogram Peaks')

