function subsubplot_showlayout(top)
%function subsubplot_showlayout(top)
%
% Preview what a subsubplot structure will look like
%

% Copyright (c) 2008 Ken Schutte
% more info at: http://www.kenschutte.com/subsubplot

% simple image to display:
N = 30;
t = linspace(-5,5,N);
C = repmat(t.*t,N,1) + repmat(t'.*t',1,N);

figure;
colormap(jet)
H = subsubplot(top);

for i=1:length(H)
  subplot(H(i));
  imagesc(t,t,C);
  text(0,0,num2str(i),'color','white','verticalalignment','middle','horizontalalignment','center')
  axis off;
end



