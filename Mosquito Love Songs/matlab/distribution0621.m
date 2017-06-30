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
xlim([0 2000]);
xlabel('Frequency (Hz)') % x-axis label
title('Combined Harmonic Distribution')
legend('Male Harmonics')

hold on
[f1 Fs] = audioread('AAF001-062017-01.m4a');
fy1 =fft(f1);
L=length(f1);
L2=round(L/2);
fa=abs(fy1(1:L2)); % half is essential, rest is aliasing
fmax=Fs/2; % maximal frequency
fq=((0:L2-1)/L2)*fmax; % frequencies
pwrTot = bandpower(f1,Fs,[0 Fs/2]);
plot(fq,fa);
xlim([0 2000]);
legend('Male Harmonics','Female Harmonics');
hold off

finalmatrixx = []
finalmatrixy = []
%%
for index = 1:9
    %filename = strcat(strcat('male', int2str(index), '.m4a'));
 %[f1 Fs] = audioread(filename');
    
    [f1 Fs] = audioread('AAM001-062017-01.m4a');
    fy1 =fft(f1);
    L=length(f1);
    L2=round(L/2);
    fa=abs(fy1(1:L2)); % half is essential, rest is aliasing
    fmax=Fs/2; % maximal frequency
    fq=((0:L2-1)/L2)*fmax; % frequencies
    smallersectiony = fa(:, 1:2000/.0813);
    smallersectionx = fq(:, 1:2000/.0813);
    plot(smallersectionx, smallersectiony);
    peaks = zeros(1, 1)
    for i = 501:2000/.0813 - 500
        value = smallersectiony(i);
        if value == max(smallersectiony(i - 500: i+ 500))
            if value > 250
                peak = i * .0813;
                finalmatrixx = [finalmatrixx .95 + index * .01];
                finalmatrixy = [finalmatrixy peak];
            end
        end 
    end 
end 


for index = 1:4
    filename = strcat(strcat('female', int2str(index), '.m4a'));
    [f1 Fs] = audioread(filename');
    fy1 =fft(f1);
    L=length(f1);
    L2=round(L/2);
    fa=abs(fy1(1:L2)); % half is essential, rest is aliasing
    fmax=Fs/2; % maximal frequency
    fq=((0:L2-1)/L2)*fmax; % frequencies
    smallersectiony = fa(:, 1:2000/.0813 );
    smallersectionx = fq(:, 1:2000/.0813 );
    plot(smallersectionx, smallersectiony);
    peaks = zeros(1, 1)
    for i = 501:2000/.0813 - 500
        value = smallersectiony(i);
        if value == max(smallersectiony(i - 500: i+ 500))
            if value > 50
                peak = i * .0813
                finalmatrixx = [finalmatrixx 4.95 + index * .01];
                finalmatrixy = [finalmatrixy peak];
            end
        end 
    end 
end 

figure;
scatter(finalmatrixy, finalmatrixx)
xlim([0 2])