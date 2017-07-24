function subsubplot_examples()
%function subsubplot_examples()
%
% show some examples of subsubplot.m
%

% Copyright (c) 2008 Ken Schutte
% more info at: http://www.kenschutte.com/subsubplot

% ---------------------------------
clear top;
top.sp = [4 1];
top.c(1).sp = [1 2];
top.c(1).c(2).sp = [1 3];
top.c(2).sp = [1 2];
top.c(2).c(1).sp = [2 2];
top.c(2).c(1).c(1).sp = [3 3];
top.c(2).c(1).c(3).sp = [3 3];
top.c(2).c(1).c(4).sp = [3 3];
top.c(2).c(1).c(5).sp = [1 2];
top.c(2).c(1).c(21).sp = [2 2];
top.c(4).sp = [1 4];
top.c(4).c(2).sp = [2 1];
top.c(4).c(3).sp = [3 1];
top.c(4).c(4).sp = [4 1];
subsubplot_showlayout(top);
% ---------------------------------
clear top;
top.sp = [2 2];
for i=1:4
  top.c(i).sp = [2 2];
  top.c(i).c(i).sp = [2 2];
  top.c(i).c(i).c(i).sp = [2 2];
  top.c(i).c(i).c(i).c(i).sp = [2 2];
  top.c(i).c(i).c(i).c(i).c(i).sp = [2 2];
end
subsubplot_showlayout(top);




clear top;
top.sp = [2 2];
for i=1:4
  top.c(i).sp = [2 2];
  top.c(i).w = [.3 .7]+[.4 -.4]*(mod(i+1,2));
  top.c(i).h = [.3 .7]+[.4 -.4]*(i>2);

  top.c(i).c(i).sp = [2 2];
  top.c(i).c(i).w = [.3 .7]+[.4 -.4]*(mod(i+1,2));
  top.c(i).c(i).h = [.3 .7]+[.4 -.4]*(i>2);
%%%  top.c(i).w = [.3 .7];
%%%  top.c(i).h = [.3 .7];
end
subsubplot_showlayout(top);





clear top;
top.sp = [2 2];
d = [.4 .3 .2 .1];
for i=1:4
  top.c(i).sp = [2 2];
  top.c(i).w = [d(1) 1-d(1)]+(1-2*d(1)).*[1 -1]*(mod(i,2));
  top.c(i).h = [d(1) 1-d(1)]+(1-2*d(1)).*[1 -1]*(i<3);

  top.c(i).c(i).sp = [2 2];
  top.c(i).c(i).w = [d(2) 1-d(2)]+(1-2*d(2)).*[1 -1]*(mod(i,2));
  top.c(i).c(i).h = [d(2) 1-d(2)]+(1-2*d(2)).*[1 -1]*(i<3);

  top.c(i).c(i).c(i).sp = [2 2];
  top.c(i).c(i).c(i).w = [d(3) 1-d(3)]+(1-2*d(3)).*[1 -1]*(mod(i,2));
  top.c(i).c(i).c(i).h = [d(3) 1-d(3)]+(1-2*d(3)).*[1 -1]*(i<3);
end
subsubplot_showlayout(top);



























% ---------------------------------
clear top;
top.sp = [4 4];
for i=1:16
  k = round(rand(1,2)*3)+1;
  top.c(i).sp = k;
  top.c(i).pad = .03.*rand(prod(k),4);
end
subsubplot_showlayout(top);



% ---------------------------------
clear top;
top.sp = [3 3];
top.skip = 2:2:8;
subsubplot_showlayout(top);
% ---------------------------------
% note the inherited 'skip'
clear top;
top.sp = [2 2];
top.R_skip = [2 3];
top.c(1).sp = [2 2];
top.c(1).c(1).sp = [2 2];
top.c(1).c(1).c(1).sp = [2 2];
top.c(1).c(1).c(1).c(1).sp = [2 2];
top.c(1).c(1).c(1).c(1).c(1).sp = [2 2];
subsubplot_showlayout(top);

clear top;
top.sp = [2 2];
top.R_skip = [2 3];
top.c(1).sp = [2 2];
top.c(1).c(1).sp = [2 2];
top.c(1).c(1).c(1).sp = [2 2];
top.c(1).c(1).c(1).c(1).sp = [2 2];
top.c(1).c(1).c(1).c(1).c(1).sp = [2 2];
subsubplot_showlayout(top);



% ---------------------------------
clear top;
top.sp = [3 3];
top.skip = 5;
for i=1:9
  if (i~=5)
    top.c(i).sp = [3 3];
    top.c(i).skip = 5;
    for k=1:9
      if (i~=5)
	top.c(i).c(k).sp = [3 3];
	top.c(i).c(k).skip = 5;
      end
    end
  end
end
subsubplot_showlayout(top);
% ---------------------------------
clear top;
top.sp = [2 1];
top.c(1).sp = [1 1];
top.c(1).skip = [2 3];
top.c(1).c(1).sp = [2 2];
top.c(1).c(1).skip = [2 3];
%top.c(1).c(1).c(1).sp = [2 2];
%top.c(1).c(1).c(1).skip = [2 3];
%top.c(1).c(1).c(1).c(1).sp = [2 2];
%top.c(1).c(1).c(1).c(1).skip = [2 3];
%top.c(1).c(1).c(1).c(1).c(1).sp = [2 2];
%top.c(1).c(1).c(1).c(1).c(1).skip = [2 3];
subsubplot_showlayout(top);

