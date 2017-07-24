function [ output_args ] = analyzePrePost( d )
%ANALYZEALLSUBJECTS Summary of this function goes here
%   Detailed explanation goes here

    
    totalPrePostCued = [];
    totalPrePostUncued = [];
    
    for iSubject=1:length(d)
        pp = plotPrePost(d{iSubject}, 'plot', 0);
        totalPrePostCued = [totalPrePostCued pp.cuedAS - pp.cuedBS];
        totalPrePostUncued = [totalPrePostUncued pp.unCuedAS - pp.unCuedBS];
    end

    %Need to double check.  ttest2 Two-sample t-test with pooled or unpooled variance estimate.
    [H,P,CI,STATS] = ttest2(totalPrePostCued, totalPrePostUncued);
    disp(H);
    disp(P);
    disp(CI);
    disp(STATS);

    figure;
    b = bar( [totalPrePostCued totalPrePostUncued] );
    hold on;
    b = bar( [totalPrePostCued], 'facecolor', 'r'  );
    title('Total Difference: After Sleep - Before Sleep for each target in Cued and Uncued  - all 3 subjects')
    xlabel('Targets (24 for each Subejct, 72 Cued, 72 UnCued)') % x-axis label
    ylabel('Difference in Distance: Points') % y-axis label
    legend('UnCued','Cued')
    
    
    figure;
    subplot(2,1,1);
    histogram( [totalPrePostCued], 100);
    set(get(gca,'child'),'FaceColor','r');
    xlim([-500 500]);
    legend('Cued')
    
    subplot(2,1,2);
    histogram( [totalPrePostUncued], 100);
    xlim([-500 500]);
    legend('UnCued')
    
    figure;
    meanC = mean(totalPrePostCued);
    meanUn = mean(totalPrePostUncued);
    %steC = (std(totalPrePostCued))/sqrt(length(totalPrePostCued)
    %steUn = (std(totalPrePostUncued))/sqrt(length(totalPrePostUncued)
    
    meanAll = [meanC meanUn];
    %steAll = [steC steUn];
    b = bar(meanAll,0.3); 
    %hold on;
    %h=errorbar(meanAll,steAll,'r'); set(h,'linestyle','none');
    %hold on;
    %b = bar( meanC, 'facecolor', 'r'  );
    %b = bar( [mean(totalPrePostCued)], 'facecolor', 'r'  );
    
    
        
end

