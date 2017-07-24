function H=subsubplot(top)
% H = subsubplot(top)
%
% Can create complex set of axes in current figure
%
% inputs:
%   top: input structure
% outputs:
%   H: array of axes handles
%
% see subsubplot_examples.m for usage
%
% Fields applied to each node:
%
%  .skip = [array]  (which subplots to not create)
%
% 4 forms of pad:
%  .pad = 1x1 = p             (global)
%  .pad = 1x2 = [inner outer]
%  .pad = 1x4 = [t r b l]     (each side for all children)
%  .pad = Nx4 = [t r b l;     (each of N children gets 
%               t r b l;       unique pad specs)
%               t r b l;      (top right bottom left)
%               t r b l]
%
%  .init = [left bottom width height]
%
% TODO: field variables inherited to children
%       (eg .Rpad, .Rskip etc)
%

% Copyright (c) 2008 Ken Schutte
% more info at: http://www.kenschutte.com/subsubplot

global H;

H=[];
recr(top,[0 0 1 1]);

% --------------------------
%
% recursive function that does all 
%   all the work
%
% --------------------------
function recr(elmt,pos)

global H;

R = elmt.sp(1);
C = elmt.sp(2);

% top.prop = x
% top.R_prop = N
% if (no .prop or .R_prop = 0) 
%   .prop = default;
% end
% if (no .R_prop or .R_prop = 0)
%   .R_prop = 1;
% end
% 
% ...
%
% inherit:
% 
% 
% 




% set defaults, or inherit from R_*
if (~isfield(elmt,'pad'));  if (isfield(elmt,'R_pad'));  elmt.pad  = elmt.R_pad;  else elmt.pad  = 0;            end;end;
if (~isfield(elmt,'init')); if (isfield(elmt,'R_init')); elmt.init = elmt.R_init; else elmt.init = [0 0 1 1];    end;end;
if (~isfield(elmt,'skip')); if (isfield(elmt,'R_skip')); elmt.skip = elmt.R_skip; else elmt.skip = [];           end;end;
if (~isfield(elmt,'h'));    if (isfield(elmt,'R_h'));    elmt.h    = elmt.R_h;    else elmt.h    = ones(1,R)./R; end;end;
if (~isfield(elmt,'w'));    if (isfield(elmt,'R_w'));    elmt.w    = elmt.R_w;    else elmt.w    = ones(1,C)./C; end;end;

P = mysubplot(pos,[R C],elmt.pad,elmt.init,elmt.h,elmt.w);

elmt.do = ones(size(P,1),1);
elmt.do(elmt.skip) = 0;

for i=1:size(P,1)
  if (elmt.do(i))
    h = subplot('position',P(i,:)); box;
    if (checkRecr(elmt,i))
      % inherit recursive (R_) properties:
      if (isfield(elmt,'R_pad')  && ~isfield(elmt.c(i),'R_pad'));  elmt.c(i).R_pad=elmt.R_pad;end
      if (isfield(elmt,'R_init') && ~isfield(elmt.c(i),'R_init')); elmt.c(i).R_init=elmt.R_init;end
      if (isfield(elmt,'R_skip') && ~isfield(elmt.c(i),'R_skip')); elmt.c(i).R_skip=elmt.R_skip;end
      if (isfield(elmt,'R_h')    && ~isfield(elmt.c(i),'R_h'));    elmt.c(i).R_h=elmt.R_h;end
      if (isfield(elmt,'R_w')    && ~isfield(elmt.c(i),'R_w'));    elmt.c(i).R_w=elmt.R_w;end
      % run on child:
      recr(elmt.c(i),P(i,:));
    else
      H(end+1) = h;
    end
  end
end

% --------------------------
%
% see if you should take another
%  step in recursion
%
% --------------------------
function y=checkRecr(elmt,i)

y=0;
if ( isfield(elmt,'c') && length(elmt.c)>=i && length(elmt.c(i).sp)>0 )
  y=1;
end;


% --------------------------
%
% break a rectange area into a grid
%  of smaller rectanges
% 
% --------------------------
function P=mysubplot(pos,sp,pad,init,h,w)

pos(1:2) = pos(1:2) + init(1:2).*pos(3:4); % add left/bottom as fraction of width/height
pos(3:4) = pos(3:4).*init(3:4);            % scale width/height

R = sp(1);
C = sp(2);
N = R*C;

bottoms = pos(2) + pos(4).*(1-cumsum(h));
lefts = pos(1)+[0 cumsum(pos(3).*w(1:end-1))];

P(:,1) = repmat(lefts', R, 1);
P(:,2) = reshape(repmat(bottoms, C, 1),N,1);
P(:,3) = repmat(pos(3).*w,1,R);
P(:,4) = reshape(repmat(pos(4).*h,C,1),1,N);

% check different versions of pad:
if (length(pad)==1)
  pad = repmat(pad,N,4);
elseif (size(pad)==[1 4])
  pad = repmat(pad,N,1);
elseif (size(pad)==[1 2])
  pad = repmat(pad(1),N,4);
  % change "outer" edges:
  pad(1:C                ,1) = pad(2); % top
  pad(C:C:(R*C)          ,2) = pad(2); % right
  pad(((R-1)*C+1):(R*C)  ,3) = pad(2); % bottom
  pad(1:C:((R-1)*C+1)    ,4) = pad(2); % left
elseif (size(pad)==[N 4])
  % okay
else
  error('bad shape for .pad');
end

% apply the padding:
P(:,1) = P(:,1) + pad(:,4);
P(:,2) = P(:,2) + pad(:,3);
P(:,3) = P(:,3) - pad(:,2) - pad(:,4);
P(:,4) = P(:,4) - pad(:,1) - pad(:,3);
