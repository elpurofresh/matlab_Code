%function treeplot_Andres(p,c,d)
function treeplot_Andres(p, ref)
%TREEPLOT Plot picture of tree.
%   TREEPLOT(p) plots a picture of a tree given a row vector of
%   parent pointers, with p(i) == 0 for a root. 
%
%   TREEPLOT(P,nodeSpec,edgeSpec) allows optional parameters nodeSpec
%   and edgeSpec to set the node or edge color, marker, and linestyle.
%   Use '' to omit one or both.
%
%   Example:
%      treeplot([2 4 2 0 6 4 6])
%   returns a complete binary tree.
%
%   See also ETREE, TREELAYOUT, ETREEPLOT.

%   Copyright 1984-2009 The MathWorks, Inc. 
%   $Revision: 5.12.4.3 $  $Date: 2009/04/21 03:26:23 $

[x,y,h]=treelayout(p);
f = find(p~=0);
pp = p(f);
%X = [x(f); x(pp); repmat(NaN,size(f))];
%Y = [y(f); y(pp); repmat(NaN,size(f))]; %NaN(x,y) has better performance
%than repmat(NaN, x, y)
X = [x(f); x(pp); NaN(size(f))]; 
Y = [y(f); y(pp); NaN(size(f))];
X = X(:);
Y = Y(:);


plot (floor(x(ref)*10), floor(y(ref)*10), 'b+', floor(X(ref)*10), floor(Y(ref)*10), 'r-');
plot (floor(x*10), floor(y*10), 'ro', floor(X*10), floor(Y*10), 'r-');


% if nargin == 1,
%     n = length(p);
%     if n < 500,
%         plot (floor(x*10), floor(y*10), 'ro', floor(X*10), floor(Y*10), 'r-');
%     else
%         plot (X, Y, 'r-');
%     end;
% else
%     [~, clen] = size(c);
%     if nargin < 3, 
%         if clen > 1, 
%             d = [c(1:clen-1) '-']; 
%         else
%             d = 'r-';
%         end;
%     end;
%     [~, dlen] = size(d);
%     if clen>0 && dlen>0
%         plot (x, y, c, X, Y, d);
%     elseif clen>0,
%         plot (x, y, c);
%     elseif dlen>0,
%         plot (X, Y, d);
%     else
%     end;
% end;
% xlabel(['height = ' int2str(h)]);

%set(text(floor(x(1)*10)+0.2, floor(y(1)*10)+0.2, 'ReferenceNode', 'VerticalAlignment','bottom', 'HorizontalAlignment','left'), 'BackgroundColor', [1 1 1]);
annotation('textarrow', [x(ref)-0.15 x(ref)], [y(ref)+((y(ref)*2)/100) y(ref)], 'String' , 'Reference Node');

xlabel(['x tree coordinates']);
ylabel(['y tree coordinates']);
%Sets limits of both x-y axes [min_x max_x min_y max_Y]
axis([0 10 0 10]);


