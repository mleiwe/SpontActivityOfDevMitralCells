function mnl_PlotScale(Data,Scale,Length,Color,UnitsName,Orient)
%Plots a 100 unit scale bar at the bottom-right of the figure.
% Based on the code plot_scale created by Eran Oflek (provided as a nested
% function below
%
% Created by Marcus Leiwe, Kyushu Univeristy, 2019

%% Find bottom right
xyz=size(Data);
X=xyz(2);
Y=xyz(1);

X1=X*0.95;
Y1=Y*0.95;
xPos=round(X1-((Length/Scale)*0.5));
yPos=round(Y1);
Pos=[xPos yPos];

%% Plot Scale Bar
[Hscale,Htext]=plot_scale(Pos,Scale,Length,Color,UnitsName,Orient);

%% Nested Function
function [Hscale,Htext]=plot_scale(Pos,Scale,Length,Color,UnitsName,Orient);
%-------------------------------------------------------------------
% plot_scale function                                      Plotting
% Description: Add a scale bar on a plot or image.
% Input  : - Scale bar position [X, Y].
%          - Scale [Units per pixel].
%          - Scale bar length in units (e.g., arcsec).
%          - Color, default is 'w';
%          - Units name, default is 'um'.
%          - Scale bar orientation:
%            'h' - Horizontal (default).
%            'v' - Vertical. 
% Output : - Handle for the scale line.
%          - Handle for the text.
% Tested : Matlab 7.0
%     By : Eran O. Ofek                      July 2005
%    URL : http://wise-obs.tau.ac.il/~eran/matlab.html
% Reliable: 2
%-------------------------------------------------------------------
DistFactor = 0.05;
if (nargin==3),
   Color     = 'w';
   UnitsName = 'um';
   Orient    = 'h';
elseif (nargin==4),
   UnitsName = 'um';
   Orient    = 'h';
elseif (nargin==5),
   Orient    = 'h';
elseif (nargin==6),
   % do nothing
else
   error('Illegal Number of input arguments');
end

NextPlot = get(gca,'NextPlot');
hold on;

XLim   = get(gca,'XLim');
YLim   = get(gca,'YLim');
Xdiff  = abs(diff(XLim));
Ydiff  = abs(diff(YLim));

switch Orient
 case 'h'
    LineX = Pos(1) + 0.5.*Length./Scale.*[-1;+1];
    LineY = Pos(2).*[+1;+1];
    DistXdir = 0;
    DistYdir = -1;
 case 'v'
    LineX = Pos(1).*[+1;+1];
    LineY = Pos(2) + 0.5.*Length./Scale.*[-1;+1];
    DistXdir = +1;
    DistYdir = 0;
 otherwise
    error('Unknown Orient Option');
end

%--- plot line ---
Hscale = plot(LineX,LineY,'LineWidth',2);
set(Hscale,'Color',Color);

%--- plot text ---
DistX    = DistXdir.*DistFactor.*Xdiff;
DistY    = DistYdir.*DistFactor.*Ydiff;

Htext    = text(Pos(1)+DistX,Pos(2)+DistY,sprintf('%5.1f %s',Length,UnitsName));

switch Orient,
 case 'h'
    % do nothing
 case 'v'
    set(Htext,'Rotation',90);
 otherwise
    error('Unknown Orient Option');
end
set(Htext,'HorizontalAlignment','center','Color',Color);

set(gca,'XLim',XLim);
set(gca,'YLim',YLim);

set(gca,'NextPlot',NextPlot);