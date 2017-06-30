%% variables
fs = 44100;
sizeOfWindow = 44100; % increasing value increases frequency resolution
overlap = round(0.95*sizeOfWindow);
threshold = 8;
% hc = harmonically converging pair

%% Reads in sound clips for paired recordings
[hc1,Fs] = audioread('AAM026AAF031-062817-13.wav');
[hc2,Fs] = audioread('AAM026AAF036-062817-14.wav');
[hc3,Fs] = audioread('AAM027AAF031-062817-15.wav');
[hc4,Fs] = audioread('AAM027AAF036-062817-14.wav');
[NOISE, Fs] = audioread('FAN NOISE-062817 copy.wav');

hc1 = hc1(:,1); % hc M26 F31
hc2 = hc2(:,1); % hc M26 F36
hc3 = hc3(:,1); % hc M27 F31
hc4 = hc4(:,1); % hc M27 F36
NOISE = NOISE(:,1); % hc NOISE clip

%% spectrogram of noise clip
[s2, fr,t] = spectrogram(NOISE, sizeOfWindow, overlap, [], fs, 'yaxis');
pNOISE = abs(s2);
pNOISE = pNOISE(:,:);
topFreq = 2000;
im = [];
im(:,:,3) = (pNOISE(1:topFreq,:)>threshold)*255; 
im(:,:,2) = (pNOISE(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pNOISE(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Spectrogram: Converging Pairs - NOISE Recording')

%% spectrgram 1: M26 F31
t1 = 1.16; % time of recording = 1.16 sec
[s2, fr,t] = spectrogram(hc1, sizeOfWindow*t1, overlap, [], fs, 'yaxis');
phc1 = abs(s2);
%phc1 = phc1(:,:);
%pHC1(1:200,:) = zeros(200, size(pNOISE,2));
topFreq = 2000;

im = [];
im(:,:,3) = (phc1(1:topFreq,:)>threshold)*255;
im(:,:,2) = (phc1(1:topFreq,:)>threshold)*255; 
im(:,:,1) = (phc1(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Spectrogram: Converging Pairs - Male 26 & Female 31')

%% spectrogram 2: M26 F36
t2 = 1.31; % time of recording = 1.31 sec
[s2, fr,t] = spectrogram(hc2, sizeOfWindow*t2, overlap, [], fs, 'yaxis');
phc2 = abs(s2);
phc2 = phc2(:,:);
topFreq = 2000;

im = [];
im(:,:,3) = (phc2(1:topFreq,:)>threshold)*255; 
im(:,:,2) = (phc2(1:topFreq,:)>threshold)*255;
im(:,:,1) = (phc2(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Spectrogram: Converging Pairs - Male 26 & Female 36')

%% spectrogram 3: M27 F31
t3 = 1.34; % time of recording = 1.31 sec
[s2, fr,t] = spectrogram(hc3, sizeOfWindow, overlap, [], fs, 'yaxis');
phc3 = abs(s2);
phc2 = phc3(:,:);
topFreq = 2000;

im = [];
im(:,:,3) = (phc3(1:topFreq,:)>threshold)*255;
im(:,:,2) = (phc3(1:topFreq,:)>threshold)*255;
im(:,:,1) = (phc3(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Spectrogram: Converging Pairs - Male 27 & Female 31')

%% spectrogram 4: M27 F36
t4 = 1.15; % time of recording = 1.15 sec
[s2, fr,t] = spectrogram(hc4, sizeOfWindow, overlap, [], fs, 'yaxis');
phc4 = abs(s2);
phc4 = phc4(:,:);
topFreq = 2000;

im = [];
im(:,:,3) = (phc4(1:topFreq,:)>threshold)*255; 
im(:,:,2) = (phc4(1:topFreq,:)>threshold)*255;
im(:,:,1) = (phc4(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Spectrogram: Converging Pairs - Male 27 & Female 36')