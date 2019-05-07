function asl_split_nii(option)

[filename, working_dir] = uigetfile(...
    {'*.nii','Image-files (*.nii)';...
    '*.nii', 'NIFTI files (*.nii) - output format'}, ...
    'Pick an image file','MultiSelect','off');

if isempty(filename)
    error('Need a file... exiting');
end

img = load_nii(fullfile(working_dir,filename));
voxel_size = [img.hdr.dime.pixdim(2) img.hdr.dime.pixdim(3) img.hdr.dime.pixdim(4)];

if size(img.img,3) == 1 && size(img.img,4) > 1 % then 4D
    num_time_frames = size(img.img,4);
else
    num_time_frames = size(img.img,3);
end

[p,n,e]=fileparts(filename);

fprintf('\nSplitting... progress (%%): \n0');
del_text   = sprintf('\b\b');

for loop=1:num_time_frames
    percent_x = round(100*loop/num_time_frames);
    fprintf('%s%d\n',del_text,percent_x);
    if percent_x > 0
        del_text   = sprintf(repmat('\b',1,2+floor(log10(percent_x))));
    end
    
    new_filename = fullfile(working_dir,strcat(n,'_',num2str(rem(floor(loop/1000),10),'%d'),num2str(rem(floor(loop/100),10),'%d'),num2str(rem(floor(loop/10),10),'%d'),num2str(rem(floor(loop/1),10),'%d'),e));
if exist('option','var')
    if option == 1
        nii = make_nii(img.img(:,:,loop), voxel_size);
    end
    if option == 2
        nii = make_nii(repmat(img.img(:,:,loop),[1,1,15]),voxel_size);
    end
else 
    nii = make_nii(img.img(:,:,loop));
end
    save_nii(nii, new_filename);
end

end
