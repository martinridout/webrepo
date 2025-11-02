% DESCRIPTION
% Plots a 3-dim array as a 2-dim scatterplot with colour for 3rd dim.
%
% SYNTAXIS
% g = tool_plot(L,crange,mark)
% where
%       L:      3-dim array (dims as columns)
%       crange: range of color indices
%       mark:   marker character and size      
%       g:      figure handle for the plot
%       
% NOTES
% Stream down of plot3k by Ken Garrard, North Carolina State University 

function g = tool_plot(L,crange,mark)

% plot based on z values
c = L(:,3);

% get marker
if isempty(mark), mark  = {'.',4};end
mark_ch = mark{1}; mark_sz = max(0.5,mark{2});

% find color limits and range
if isempty(crange)   min_c = min(c);  max_c   = max(c);
else                 min_c = crange(1); max_c = crange(2);end
range_c = max_c - min_c;

% get current colormap
cmap = colormap; clen = length(cmap);
if range_c < 0, cmap = flipud(cmap); end

% calculate index to color map for all points and sort by colormap index
L(:,4) = min(max(round((c-min(min_c,max_c))*(clen-1)/abs(range_c)),1),clen);
L = sortrows(L,4);

% build index vector of color transitions (last point for each color)
dLix = [find(diff(L(:,4))>0); size(L,1)];

% plot data points in groups by color map index
hold on;                           
s = 1;                             
for k = 1:size(dLix,1)             % call plot3 once for each color group
   plot3(L(s:dLix(k),1),L(s:dLix(k),2),L(s:dLix(k),3), ...
       mark_ch,'MarkerSize',mark_sz, ...
      'MarkerEdgeColor',cmap(L(s,4),:),'MarkerFaceColor',cmap(L(s,4),:));   
   s = dLix(k)+1;                  % next group starts at next point
end
hold off;

% set plot characteristics
view(2);grid off;

if nargout > 0, g = gcf; end             % return figure handle

return