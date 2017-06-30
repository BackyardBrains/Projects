fs = 44100;

% female
[s2, fr,t] = spectrogram(f, 20000, [], [], fs, 'yaxis');
pf = abs(s2);
pf = pf(:,:);
pf(1:200,:) = zeros(200, size(pf,2));
topFreq = 1800;
threshold = 2;
im = [];
im(:,:,3) = (pf(1:topFreq,:)>threshold)*255;
im(:,:,2) = (pf(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pf(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

% male
[s2, fr,t] = spectrogram(m, 20000, [], [], fs, 'yaxis');
pm = abs(s2);
pm1 = pm(:,1:size(pf,2));
pm1(1:250,:) = zeros(250, size(pm1,2));
topFreq = 2500;
threshold = 2;
im = [];

% combined
im(:,:,3) = (pf(1:topFreq,:)>threshold)*255+(pm1(1:topFreq,:)>threshold)*50; % combined spectrogram of male and female
im(:,:,2) = (pf(1:topFreq,:)>threshold)*255+(pm1(1:topFreq,:)>threshold)*255;
im(:,:,1) = (pf(1:topFreq,:)>threshold)*50+(pm1(1:topFreq,:)>threshold)*255;

image('XData',t,'YData',fr(1:topFreq),'CData',im);
image(255-im);
set(gca,'ydir','normal')

xlabel('Time (ms)') % x-axis label
ylabel('Frequency (Hz)');
title('Clear Combined Spectrogram: Male & Female Recordings')