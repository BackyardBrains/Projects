%% Reads in sound clips for all female recordings
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

hold on
[f14 Fs] = audioread('AAF014-062717-06.wav');
fy14 =fft(f14);
L=length(f14);
L2=round(L/2);
fa=abs(fy14(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f14,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f20 Fs] = audioread('AAF020-062717-06.wav');
fy20 =fft(f20);
L=length(f20);
L2=round(L/2);
fa=abs(fy20(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f20,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f22 Fs] = audioread('AAF022-062717-06.wav');
fy22 =fft(f22);
L=length(f20);
L2=round(L/2);
fa=abs(fy22(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f22,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f23 Fs] = audioread('AAF023-062717-06.wav');
fy23 =fft(f23);
L=length(f23);
L2=round(L/2);
fa=abs(fy23(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(f23,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f24 Fs] = audioread('AAF024-062717-06.wav');
fy24 =fft(f24);
L=length(f24);
L2=round(L/2);
fa=abs(fy24(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f24,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f25 Fs] = audioread('AAF025-062717-06.wav');
fy25 =fft(f25);
L=length(f25);
L2=round(L/2);
fa=abs(fy25(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f25,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f26 Fs] = audioread('AAF026-062717-06.wav');
fy26 =fft(f26);
L=length(f26);
L2=round(L/2);
fa=abs(fy20(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
%pwrTot = bandpower(f26,Fs,[0 Fs/2]);
plot(fq,fa);

hold on
[f27 Fs] = audioread('AAF027-062717-06.wav');
fy27 =fft(f27);
L=length(f27);
L2=round(L/2);
fa=abs(fy27(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f27,Fs,[0 Fs/2]);
plot(fq,fa);


L=legend('AAF001','AAF002','AAF003','AAF004','AAF005','AAF008','AAF013','AAF014','AAF020', 'AAF022','AAF023','AAF024','AAF025','AAF026','AAF027');
set(L,'linewidth',1);

hold off

%% female spectrogram
% f1 = f1(:,1);
% f2 = f2(:,1);
% f3 = f3(:,1);
% f4 = f4(:,1);
% f5 = f5(:,1);
% f8 = f8(:,1);
% f13 = f13(:,1);
% f14 = f14(:,1);
% f20 = f20(:,1);
% f22 = f22(:,1);
f23 = f23(:,1);
% f24 = f24(:,1);
% f25 = f25(:,1);
f26 = f26(:,1);
f27 = f27(:,1);

f = [f23; f26; f27];

m12 = m12(:,1);
% m13 = m13(:,1);
m14 = m14(:,1);
m16 = m16(:,1);
% m17 = m17(:,1);
m18 = m18(:,1);
% m19 = m19(:,1);

m = [m12; m14; m16; m18];

[s2, fr,t] = spectrogram(f, 20000, [], [], fs, 'yaxis');
pf = abs(s2);
pf = pf(:,:);
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pf(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pf(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pf(1:topFreq,:)>threshold)*50;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Spectrogram: All Female Recordings')

[s2, fr,t] = spectrogram(m, 20000, [], [], fs, 'yaxis');
pm = abs(s2);
%pm16 = pm16(:,:);
pm1 = pm(:,1:size(pf,2));
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pf(1:topFreq,:)>threshold)*255+(pm1(1:topFreq,:)>threshold)*50; % combined spectrogram of male and female
im(:,:,2) = (pf(1:topFreq,:)>threshold)*255+(pm1(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pf(1:topFreq,:)>threshold)*50+(pm1(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Female 23 Male 16')


%% female 23 spectrogram
f23 = f23(:,1);

[s2, fr,t] = spectrogram(f23, 20000, [], [], fs, 'yaxis');
pf23 = abs(s2);
pf23 = pf23(:,:);
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pf23(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pf23(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pf23(1:topFreq,:)>threshold)*50;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Individual Spectrogram: Female 23')

m16 = m16(:,1);

[s2, fr,t] = spectrogram(m16, 20000, [], [], fs, 'yaxis');
pm16 = abs(s2);
%pm16 = pm16(:,:);
pm1 = pm16(:,1:size(pf23,2));
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pf23(1:topFreq,:)>threshold)*255+(pm1(1:topFreq,:)>threshold)*50; % combined spectrogram of male and female
im(:,:,2) = (pf23(1:topFreq,:)>threshold)*255+(pm1(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pf23(1:topFreq,:)>threshold)*50+(pm1(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Female 23 Male 16')