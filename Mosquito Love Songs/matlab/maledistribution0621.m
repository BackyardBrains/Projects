%Reads in sound clips for all female recordings
[m1,fs1m] = audioread('AAM001-062017-01.m4a');
[m2,fs2m] = audioread('AAM002-062117-02.m4a');
[m3,fs3m] = audioread('AAM003-062117-02.m4a');
[m7,fs4m] = audioread('AAM004-062117-02.m4a');
[m7,fs5m] = audioread('AAM005-062117-02.m4a');
[m7,fs6m] = audioread('AAM006-062117-03.m4a');
[m7,fs7m] = audioread('AAM007-062117-03.m4a');
[m8,fs8m] = audioread('AAM008-062117-03.m4a');
[m9,fs9m] = audioread('AAM009-062117-03.m4a');

% Reads noise clips for session 2 and 3
[noise2,fs2] = audioread('NOISE-062117-02.m4a');
[noise3,fs3] = audioread('NOISE-062117-03.m4a');

%% Spectrogram analysis, frequency distribution
[m1 Fs] = audioread('AAM001-062017-01.m4a');
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
[m2 Fs] = audioread('AAM002-062117-02.m4a');
my2 =fft(m2);
L=length(m2);
L2=round(L/2);
fa=abs(my2(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m2,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m3 Fs] = audioread('AAM003-062117-02.m4a');
my3 =fft(m3);
L=length(m3);
L2=round(L/2);
fa=abs(my3(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m3,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m4 Fs] = audioread('AAM004-062117-02.m4a');
my4 =fft(m4);
L=length(m4);
L2=round(L/2);
fa=abs(my4(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m4,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m5 Fs] = audioread('AAM005-062117-02.m4a');
my5 =fft(m5);
L=length(m5);
L2=round(L/2);
fa=abs(my5(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m5,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m6 Fs] = audioread('AAM006-062117-03.m4a');
my6 =fft(m6);
L=length(m6);
L2=round(L/2);
fa=abs(my6(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m6,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m7 Fs] = audioread('AAM007-062117-03.m4a');
my7 =fft(m7);
L=length(m7);
L2=round(L/2);
fa=abs(my7(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m7,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m8 Fs] = audioread('AAM008-062117-03.m4a');
my8 =fft(m8);
L=length(m8);
L2=round(L/2);
fa=abs(my8(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m8,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[m9 Fs] = audioread('AAM009-062117-03.m4a');
my9 =fft(m9);
L=length(m9);
L2=round(L/2);
fa=abs(my9(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(m9,Fs,[0 Fs/2]);
plot(fq,fa);
L=legend('AAM001','AAM002','AAM003','AAM004','AAM005','AAM006','AAM007','AAM008','AAM009');
set(L,'linewidth',1);

hold off