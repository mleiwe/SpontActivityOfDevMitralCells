function [Data,spf,scale,name]=mnl_LoadImage
% Loads the image into MATLAB, and extracts the metadata pertaining to the
% frame rate, scale, and name of file
%
% Additional Code required
% bfopen (from http://downloads.openmicroscopy.org/bio-formats/5.0.4/)
%
% Outputs
% Data - The Image series (x*y*t)
% spf - frame rate in seconds per frame
% scale - um per pixel
% name - the desired workspace name
%
% Created by Marcus Leiwe, Kyushu University, 2019
file=bfopen; %Select the desired image

series1 = file{1, 1};
sz=size(series1);
for t=1:sz(1)
    a=series1{t,1};
    Data(:,:,t)=double(a);
end

name=series1{1,2};
if size(file,1)>1 %i.e. if its an OIB/OIF file
    series2 = file{2, 1}; % referenceimage
    metadata = file{1, 2}; %Extracts the metadata
    % Get thee frame rate (Global Time Per Frame)
    spf = metadata.get('Global Time Per Frame');
    spf = str2num(spf);
    spf = spf/1000000;
    %Obtain scale
    scale = metadata.get('Global [Reference Image Parameter] WidthConvertValue'); % value in um per px
    scale=str2num(scale);
    
    series1 = file{1, 1};
    sz=size(series1);
else
    prompt='Please input the frame rate in seconds per frame (spf)';
    spf=input(prompt);
    prompt='Please input the scale in um per pixel';
    scale=input(prompt);
    prompt='Please input the name of the image';
    name=input(prompt,'s');
end 
end
