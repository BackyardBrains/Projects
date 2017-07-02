%Reads in sound clips for all female recordings
[m1,fs1m] = audioread('AAM001-062017-01.wav');
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

%% Spectrogram analysis, frequency distribution
[m1 Fs] = audioread('AAM001-062017-01.wav');
my1 =fft(m1);
L=length(m1);
L2=round(L/2);
fa=abs(my1(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m1,Fs,[0 Fs/2]);
plot(fq,fa);
xlim([300 2500]);
xlabel('Frequency (Hz)') % x-axis label
title('Male Harmonic Distribution')

hold on
[m2 Fs] = audioread('AAM002-062117-02.wav');
my2 =fft(m2);
L=length(m2);
L2=round(L/2);
fa=abs(my2(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m2,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m3 Fs] = audioread('AAM003-062117-02.wav');
my3 =fft(m3);
L=length(m3);
L2=round(L/2);
fa=abs(my3(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m3,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m4 Fs] = audioread('AAM004-062117-02.wav');
my4 =fft(m4);
L=length(m4);
L2=round(L/2);
fa=abs(my4(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m4,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m5 Fs] = audioread('AAM005-062117-02.wav');
my5 =fft(m5);
L=length(m5);
L2=round(L/2);
fa=abs(my5(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m5,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m6 Fs] = audioread('AAM006-062117-03.wav');
my6 =fft(m6);
L=length(m6);
L2=round(L/2);
fa=abs(my6(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m6,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m7 Fs] = audioread('AAM007-062117-03.wav');
my7 =fft(m7);
L=length(m7);
L2=round(L/2);
fa=abs(my7(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m7,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m8 Fs] = audioread('AAM008-062117-03.wav');
my8 =fft(m8);
L=length(m8);
L2=round(L/2);
fa=abs(my8(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m8,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m9 Fs] = audioread('AAM009-062117-03.wav');
my9 =fft(m9);
L=length(m9);
L2=round(L/2);
fa=abs(my9(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m9,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m11 Fs] = audioread('AAM011-062717-06.wav');
my11 =fft(m11);
L=length(m11);
L2=round(L/2);
fa=abs(my11(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m11,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m12 Fs] = audioread('AAM012-062717-06.wav');
my12 =fft(m12);
L=length(m12);
L2=round(L/2);
fa=abs(my12(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m12,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m13 Fs] = audioread('AAM013-062717-06.wav');
my13 =fft(m13);
L=length(m13);
L2=round(L/2);
fa=abs(my13(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m13,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m14 Fs] = audioread('AAM014-062717-06.wav');
my14 =fft(m14);
L=length(m14);
L2=round(L/2);
fa=abs(my14(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m14,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m16 Fs] = audioread('AAM016-062717-06.wav');
my16 =fft(m16);
L=length(m16);
L2=round(L/2);
fa=abs(my16(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m16,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m17 Fs] = audioread('AAM017-062717-06.wav');
my17 =fft(m17);
L=length(m17);
L2=round(L/2);
fa=abs(my17(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(m17,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m18 Fs] = audioread('AAM018-062717-06.wav');
my18 =fft(m18);
L=length(m18);
L2=round(L/2);
fa=abs(my18(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m18,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m19 Fs] = audioread('AAM019-062717-06.wav');
my19 =fft(m19);
L=length(m19);
L2=round(L/2);
fa=abs(my19(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m19,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m20 Fs] = audioread('AAM020-062717-06.wav');
my20 =fft(m20);
L=length(m20);
L2=round(L/2);
fa=abs(my20(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m20,Fs,[0 Fs/2]);
plot(fq,fa);

L=legend('AAM001','AAM002','AAM003','AAM004','AAM005','AAM006','AAM007','AAM008','AAM009','AAM011','AAM012','AAM013','AAM014','AAM016','AAM017','AAM018','AAM019','AAM020');
set(L,'linewidth',1);

hold off

%% male spectrogram
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


m = [m1; m2; m3; m4; m5; m6; m7; m8; m9; m11; m12; m13; m14; m16; m17; m18; m19; m20];

[s2, fr,t] = spectrogram(m, 20000, [], [], fs, 'yaxis');
pm = abs(s2);
pm = pm(:,:);
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pm(1:topFreq,:)>threshold)*50;
im(:,:,2) = (pm(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pm(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Spectrogram: All Male Recordings')

%% male 16 spectrogram
m16 = m16(:,1);

[s2, fr,t] = spectrogram(m16, 20000, [], [], fs, 'yaxis');
pm16 = abs(s2);
pm16 = pm16(:,:);
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pm16(1:topFreq,:)>threshold)*50;
im(:,:,2) = (pm16(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pm16(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Individual Spectrogram: Male 16')