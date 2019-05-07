function [raw_nii,rot_nii]=mnl_MakeSaveNifti(Data,scale,spf,name)
% mnl_MakeSaveNifti converts a timelapse image (saved as a double) into a
% nifti and saves it into the current directory
%
% Inputs
% Data - x,y,t in a douuble form
% scale - scale extracted from mnl_LoadImage
% spf - frame rate
% name - the name of the image
%
% Outputs
% raw_nii - the nifti version of the Data

%% Switch it to a nifti and then save it as a nifti
voxelsize=[scale,scale,spf];
raw_nii=make_nii(Data,voxelsize);
rot_nii=raw_nii';
[~,struc]=fileattrib; % get the current directory
fn=sprintf('%s%s%s%s',struc.Name,'\',name,'.nii');
save_nii(rot_nii,fn);
end