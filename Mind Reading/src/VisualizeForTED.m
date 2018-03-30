Subject = 37; %2,6,28,31,37

Location = 1;
LocationString = s{1,Subject}.eegLocations(Location);
titleText = ['EEG response for Face stimulus (Subject: MR', num2str(Subject,'%02.f'), ' Location: ', LocationString{1,1},')'];

ERPs = s{1,Subject}.erp{1,1}.trialERPs;
ERPsFirst = ERPs(:,:,Location);
numberOfStimuli = size(ERPsFirst,1);  
t= [-0.5,0.5];
fs = 556;
timeAxis = linspace(t(1),t(2),(t(2)-t(1))*fs);


figure;
title(titleText)
hold on;
h = imagesc(ERPsFirst);
set(h, 'XData', [t(1) t(2)]);
xlim([-0.5,0.5]);
xlabel({'Time [Seconds]'})
ylabel({'Stimulus #'})
hold off;


figure;
title(titleText)
hold on;
h = surf(ERPsFirst);
set(h, 'XData',timeAxis);
xlim([-0.5,0.5]);
xlabel({'Time [Seconds]'})
ylabel({'Stimulus #'})
%zlabel({'EEG amplitude'})
set(gca, 'ZTick', []);
hold off;

figure;
hold on;
ylim([-1 numberOfStimuli+1]);
for i=1:size(ERPsFirst,1)
h = plot(timeAxis,(0.5/mean(std(ERPsFirst)))*ERPsFirst(i,:)+i,'b');
hold on;
end

%xlim([1,numberOfStimuli]);
xlabel({'Time [Seconds]'});
ylabel({'Stimulus #'});
title(titleText);

hold off;