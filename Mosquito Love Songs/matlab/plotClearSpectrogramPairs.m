fs = 44100;

%% female male
[s2, fr,t] = spectrogram(fm, 20000, [], [], fs, 'yaxis');
pfm = abs(s2);
pfm = pfm(:,:);
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pfm(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pfm(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pfm(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Female Male Pairing')

%% female 23 male 12
[s2, fr,t] = spectrogram(fm1, 20000, [], [], fs, 'yaxis');
pfm1 = abs(s2);
pfm1 = pfm1(:,:);
pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pfm1(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pfm1(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pfm1(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Female 23 Male 12 Pairing')

%% female 23 male 16
[s2, fr,t] = spectrogram(fm2, 20000, [], [], fs, 'yaxis');
pfm2 = abs(s2);
pfm2 = pfm2(:,:);
pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pfm2(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pfm2(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pfm2(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Female 23 Male 16 Pairing')

%% female 26 male 18
[s2, fr,t] = spectrogram(fm3, 20000, [], [], fs, 'yaxis');
pfm3 = abs(s2);
pfm3 = pfm3(:,:);
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pfm3(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pfm3(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pfm3(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')
xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Female 26 Male 18 Pairing')

%% female 27 male 18
[s2, fr,t] = spectrogram(fm4, 20000, [], [], fs, 'yaxis');
pfm4 = abs(s2);
pfm4 = pfm4(:,:);
%pfm(1:200,:) = zeros(200, size(pfm,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pfm4(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pfm4(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pfm4(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Female 27 Male 18 Pairing')


%% male female
[s2, fr,t] = spectrogram(mf, 20000, [], [], fs, 'yaxis');
pmf = abs(s2);
%pmf1 = pmf(:,1:size(pfm,2));
pmf(1:250,:) = zeros(250, size(pmf,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pmf(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pmf(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pmf(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Male Female Pairing')

%% male 14 female 23
[s2, fr,t] = spectrogram(mf1, 20000, [], [], fs, 'yaxis');
pmf1 = abs(s2);
%pmf1 = pmf(:,1:size(pfm,2));
pmf1(1:250,:) = zeros(250, size(pmf1,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pmf1(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pmf1(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pmf1(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Male 14 Female 23 Pairing')

%% male 16 female 23
[s2, fr,t] = spectrogram(mf2, 20000, [], [], fs, 'yaxis');
pmf2 = abs(s2);
%pmf1 = pmf(:,1:size(pfm,2));
pmf2(1:250,:) = zeros(250, size(pmf2,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pmf2(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pmf2(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pmf2(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Male 16 Female 23 Pairing')

%% male 17 female 27
[s2, fr,t] = spectrogram(mf3, 20000, [], [], fs, 'yaxis');
pmf3 = abs(s2);
%pmf1 = pmf(:,1:size(pfm,2));
pmf3(1:250,:) = zeros(250, size(pmf3,2));
topFreq = 2000;
threshold = 2;
im = [];
im(:,:,3) = (pmf3(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pmf3(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pmf3(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Combined Spectrogram: Male 17 Female 27 Pairing')