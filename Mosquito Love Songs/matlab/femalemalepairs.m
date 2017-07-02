%% Reads in sound clips for all paired recordings where female is fixed and male is moving in and out of earshot
[fm1,fs1fm] = audioread('AAF023AAM012-062717-06.wav');
[fm2,fs2fm] = audioread('AAF023AAM016-062617-06.wav');
[fm3,fs3fm] = audioread('AAF026AAM018-062717-06.wav');
[fm4,fs4fm] = audioread('AAF027AAM018-062717-06.wav');

%% Spectrogram analysis, frequency distribution
[fm1,Fs] = audioread('AAF023AAM012-062717-06.wav');
fmy1 =fft(fm1);
L=length(fm1);
L2=round(L/2);
fa=abs(fmy1(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(fm1,Fs,[0 Fs/2]);
plot(fq,fa);
xlim([300 1700]);
xlabel('Frequency (Hz)') % x-axis label
title('Frequency Distribution: Female Male Pairs')

hold on
[fm2,Fs] = audioread('AAF023AAM016-062617-06.wav');
fmy2 =fft(fm2);
L=length(fm2);
L2=round(L/2);
fa=abs(fmy2(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(fm2,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[fm3,Fs] = audioread('AAF026AAM018-062717-06.wav');
fmy3 =fft(fm3);
L=length(fm3);
L2=round(L/2);
fa=abs(fmy3(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(fm3,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[fm4,Fs] = audioread('AAF027AAM018-062717-06.wav');
fmy4 =fft(fm4);
L=length(fm4);
L2=round(L/2);
fa=abs(fmy4(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(fm4,Fs,[0 Fs/2]);
plot(fq,fa);


L=legend('AAF023AAM012','AAF023AAM016','AAF026AAM018','AAF027AAM018');
set(L,'linewidth',1);

hold off

