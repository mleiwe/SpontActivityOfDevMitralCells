function [Data,scale,spf,name,raw_nii,rot_nii]=mnl_PreProcessing(workspace)

% Steps
% 1) Make it into a nifti
% 2) Split nii files
% 3) SPM8 realign
% 4) combine niftii back again
% 5) Median Filter
% 6) Save in order to run through AFID and produce Pfsm_mr'Filename'.nii

% Inputs
% workspace - name of .mat file you want saved

% Outputs
% Data - Matrix of the image
% scale - distance per pixel 
% spf - frame rate (seconds per frame)
% name - Chosen name of the Data
% raw_nii - the nifti file made
% rot_nii - the nifti file made and inverted due to differences in storage
% between tiff and nifti files.
%
% Written by Marcus Leiwe, Kyushu University 2019

%% Step 1 - Load Image and Find Glomeruli
[Data,spf,scale,name]=mnl_LoadImage;

% Remove last frame
sz=size(Data);
tData=zeros(sz(1),sz(2),(sz(3)-1));
for i=1:(sz(3)-1)
    tData(:,:,i)=Data(:,:,i);
end
Data=tData;
%% Step  2 - Make into a niftii (Prepare for SPM8 input)
[raw_nii,rot_nii]=mnl_MakeSaveNifti(Data,scale,spf,workspace);
asl_split_nii;
spm
%% Step 3 - Realign in SPM8
prompt='Run realign in SPM8, when finished type "done" then hit enter';
result=input(prompt,'s');
while 1
    test=strcmp(result,'done');
    if test==1
        break
    end
end

%% Step 4 - Combine niftii and then median filter
asl_combine_nii;
n=1;
asl_median_filter_3d(n);

%% Step 5 - Delete Split Files
for i=1:(sz(3)-1)
    fn1=sprintf('%s%s%04d%s',workspace,'_',i,'.nii');
    fn2=sprintf('%s%s%s%04d%s','r',workspace,'_',i,'.nii');
    delete(fn1,fn2);
end

%% Step 6 - Save Workspace
%fn=sprintf('%s%s',workspace,'_PreProcessedInfo');
%save(fn);
display('Now run the files through AFID to get the processed images')