%% normalizing
fm1 = fm1(:,1);
fm2 = fm2(:,1);
fm3 = fm3(:,1);
fm4 = fm4(:,1);

mf1 = mf1(:,1);
mf2 = mf2(:,1);
mf3 = mf3(:,1);

fm = [fm1; fm2; fm3; fm4];

mf = [mf1; mf2; mf3];

% plot frequency distribution
allPeaksFM = plotDistribOfFreq(fm, fs, -0.1, [0 0 1], 'Male');
hold on;
allPeaksMF = plotDistribOfFreq(mf,fs, 0.1, [255/255 105/255 180/255], 'Female');
hold off