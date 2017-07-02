%% Reads in sound clips for all female recordings
[f1,fs1f] = audioread('AAF001-062017-01.wav');
[f2,fs2f] = audioread('AAF002-062117-03.wav');
[f3,fs3f] = audioread('AAF003-062117-03.wav');
[f4,fs4f] = audioread('AAF004-062117-03.wav');
[f5,fs5f] = audioread('AAF005-062217-004.wav');
[f8,fs8f] = audioread('AAF008-062217-04.wav');
[f13,fs13f] = audioread('AAF013-062217-04.wav');

%% Spectrogram analysis, frequency distribution
[f1 Fs] = audioread('AAF001-062017-01.wav');
fy1 =fft(f1);
L=length(f1);
L2=round(L/2);
fa=abs(fy1(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f1,Fs,[0 Fs/2]);
plot(fq,fa);
xlim([300 1700]);
xlabel('Frequency (Hz)') % x-axis label
title('Female Harmonic Distribution')

hold on
[f2 Fs] = audioread('AAF002-062117-03.wav');
fy2 =fft(f2);
L=length(f2);
L2=round(L/2);
fa=abs(fy2(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(f2,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f3 Fs] = audioread('AAF003-062117-03.wav');
fy3 =fft(f3);
L=length(f3);
L2=round(L/2);
fa=abs(fy3(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f3,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f4 Fs] = audioread('AAF004-062117-03.wav');
fy4 =fft(f4);
L=length(f4);
L2=round(L/2);
fa=abs(fy4(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f4,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f5 Fs] = audioread('AAF005-062217-004.wav');
fy5 =fft(f5);
L=length(f5);
L2=round(L/2);
fa=abs(fy5(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(f5,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f8 Fs] = audioread('AAF008-062217-04.wav');
fy8 =fft(f8);
L=length(f8);
L2=round(L/2);
fa=abs(fy8(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f8,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f13 Fs] = audioread('AAF013-062217-04.wav');
fy13 =fft(f13);
L=length(f13);
L2=round(L/2);
fa=abs(fy13(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f13,Fs,[0 Fs/2]);
plot(fq,fa);
L=legend('AAF001','AAF002','AAF003','AAF004', 'AAF005', 'AAF008', 'AAF013');
set(L,'linewidth',1);

hold off