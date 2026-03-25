function [varargout] = dsxy2figxy(varargin)
if length(varargin{1}) == 1 && ishandle(varargin{1}) ...
                            && strcmp(get(varargin{1},'type'),'axes')	
    hAx = varargin{1};
    varargin(1) = [];
else
    hAx = gca;
end
if length(varargin) == 1
    pos = get(hAx,'Position');
    axlim = [get(hAx,'XLim') get(hAx,'YLim')];
    axdir = [strcmp(get(hAx,'XDir'),'reverse') strcmp(get(hAx,'YDir'),'reverse')];
    if strcmp(get(hAx,'XScale'),'log')
        axlim(1:2) = log10(axlim(1:2));
        varargin{1}(1) = log10(varargin{1}(1));
        varargin{1}(3) = log10(varargin{1}(1)+varargin{1}(3)) - varargin{1}(1);
    end
    if strcmp(get(hAx,'YScale'),'log')
        axlim(3:4) = log10(axlim(3:4));
        varargin{1}(2) = log10(varargin{1}(2));
        varargin{1}(4) = log10(varargin{1}(2)+varargin{1}(4)) - varargin{1}(2);
    end
    varargout{1} = (varargin{1}(1:2) - axlim([1 3] + axdir)) ./ (axlim([2 4]) - axlim([1 3])) .* pos(3:4) + pos(1:2);
else
    [X,Y] = deal(varargin{:});
    pos = get(hAx,'Position');
    axlim = [get(hAx,'XLim') get(hAx,'YLim')];
    axdir = [strcmp(get(hAx,'XDir'),'reverse') strcmp(get(hAx,'YDir'),'reverse')];
    if strcmp(get(hAx,'XScale'),'log')
        axlim(1:2) = log10(axlim(1:2)); X = log10(X);
    end
    if strcmp(get(hAx,'YScale'),'log')
        axlim(3:4) = log10(axlim(3:4)); Y = log10(Y);
    end
    x_fig = (X - axlim(1 + axdir(1))) / (axlim(2) - axlim(1)) * pos(3) + pos(1);
    y_fig = (Y - axlim(3 + axdir(2))) / (axlim(4) - axlim(3)) * pos(4) + pos(2);
    varargout = {x_fig, y_fig};
end