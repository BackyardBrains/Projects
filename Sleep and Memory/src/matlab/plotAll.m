% makeDB
% d=ans
% plotPrePost (d{1} )
% plotPrePost (d{2} )
% plotPrePost (d{3} )
% plotPrePost (d{4} )
% 
% ans1 = plotPrePost (d{1} );
% ans2 = plotPrePost (d{2} );
% ans3 = plotPrePost (d{3} );
% ans4 = plotPrePost (d{4} );
% 
% [y1, std1] = plotPrePostTrial(d{1});
% [y2,std2] = plotPrePostTrial(d{2});
% [y3,std3] = plotPrePostTrial(d{3});
% [y4,std4] = plotPrePostTrial(d{4});
% 
% figure;
% bar(y1,0.3)
% y = [y1;y2;y3;y4];
% std = [std1;std2;std3;std4];
% 
% yAvg = 0;
% stdAvg = 0;
 %y = mean([y1;y2;y6]);
%std = mean([std1;std2;std6]);


bar(ydiff,0.3)
%set(gca,'XTickLabel',{'CuedBS','CuedAS','UnCuedBS','UnCuedAS'})
set(gca,'XTickLabel',{'Cued','UnCued'})
hold on;
h=errorbar(y,abs(stddiff),'r'); set(h,'linestyle','none');
%title(d.subject);