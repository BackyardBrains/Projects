%% Reads in sound clips for all paired recordings where male is fixed and female is moving in and out of earshot
%% Reads in sound clips for all paired recordings where female is fixed and male is moving in and out of earshot
[mf1,fs1mf] = audioread('AAM014AAF023-062617-06.wav');
[mf2,fs2mf] = audioread('AAM016AAF023-062717-06.wav');
[mf3,fs3mf] = audioread('AAM017AAF027-062717-06.wav');

%% Spectrogram analysis, frequency distribution
[mf1,Fs] = audioread('AAM014AAF023-062617-06.wav');
mfy1 =fft(mf1);
L=length(mf1);
L2=round(L/2);
fa=abs(mfy1(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(mf1,Fs,[0 Fs/2]);
plot(fq,fa);
xlim([300 1700]);
xlabel('Frequency (Hz)') % x-axis label
title('Frequency Distribution: Male Female Pairs')

hold on
[mf2,Fs] = audioread('AAM016AAF023-062717-06.wav');
mfy2 =fft(mf2);
L=length(mf2);
L2=round(L/2);
fa=abs(mfy2(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(mf2,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[mf3,Fs] = audioread('AAM017AAF027-062717-06.wav');
mfy3 =fft(mf3);
L=length(mf3);
L2=round(L/2);
fa=abs(mfy3(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(mf3,Fs,[0 Fs/2]);
plot(fq,fa);

L=legend('AAM014AAF023','AAM016AAF023','AAM017AAF027');
set(L,'linewidth',1);

hold off