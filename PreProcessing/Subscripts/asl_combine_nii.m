function asl_combine_nii

[filename, working_dir] = uigetfile(...
    {'*.nii','Image-files (*.nii)';...
    '*.nii', 'NIFTI files (*.nii) - output format'}, ...
    'Pick a base image file to combine','MultiSelect','off');

if isempty(filename)
    error('Need a file... exiting');
end

[hdr_filename, hdr_working_dir] = uigetfile(...
    {'*.nii','Image-files (*.nii)';...
    '*.nii', 'NIFTI files (*.nii) - output format'}, ...
    'Pick an image file to steal headers (optional)','MultiSelect','off');

[p,n,e]=fileparts(filename);
output_file=strcat(n(1:length(n)-5),'.nii');
n=n(1:length(n)-5);
loop = 1;
while exist(fullfile(working_dir,strcat(n,'_',num2str(rem(floor(loop/1000),10),'%d'),num2str(rem(floor(loop/100),10),'%d'),num2str(rem(floor(loop/10),10),'%d'),num2str(rem(floor(loop/1),10),'%d'),e)),'file')==2
    loop = loop + 1;
end


num_files = loop - 1

img = load_nii(fullfile(working_dir,filename));

if isempty(hdr_filename)
    voxel_size = [img.hdr.dime.pixdim(2) img.hdr.dime.pixdim(3) img.hdr.dime.pixdim(4)];
else
    hdr_img = load_nii(fullfile(hdr_working_dir,hdr_filename));
    voxel_size = [hdr_img.hdr.dime.pixdim(2) hdr_img.hdr.dime.pixdim(3) hdr_img.hdr.dime.pixdim(4)];
    clear('hdr_img');
end

%delete(fullfile(working_dir,filename));
final_img=zeros(size(img.img,1),size(img.img,2),num_files,'int16');
final_img(:,:,1)=img.img;

fprintf('\nCombining... progress (%%): \n0');
del_text   = sprintf('\b\b');
for loop = 2:num_files
    
    img = load_nii(fullfile(working_dir,strcat(n,'_',num2str(rem(floor(loop/1000),10),'%d'),num2str(rem(floor(loop/100),10),'%d'),num2str(rem(floor(loop/10),10),'%d'),num2str(rem(floor(loop/1),10),'%d'),e)));
%    delete(fullfile(working_dir,strcat(n,'_',num2str(rem(floor(loop/1000),10),'%d'),num2str(rem(floor(loop/100),10),'%d'),num2str(rem(floor(loop/10),10),'%d'),num2str(rem(floor(loop/1),10),'%d'),e)));
    percent_x = round(100*loop/num_files);
    fprintf('%s%d\n',del_text,percent_x);
    if percent_x > 0
        del_text   = sprintf(repmat('\b',1,2+floor(log10(percent_x))));
    end
    
    final_img(:,:,loop)=img.img;
end

nii = make_nii(final_img, voxel_size);
save_nii(nii, output_file);

end
