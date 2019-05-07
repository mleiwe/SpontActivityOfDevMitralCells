function asl_median_filter_3d(n)
%% median filter

ff=uipickfiles;

for l=1:numel(ff)
    nii = load_nii(ff{l});
    img = nii.img;
    
    loop=1;
    
    z_size = size(img,3);
    
    img = asl_zero_pad_matrix(1,img,n);
    nimg=img;
    
    %progressbar('Filtering');
    
    for x_loop=n+1:size(img,1)-n-1
        %progressbar(x_loop/(size(img,1)-2*n));
        for y_loop=n+1:size(img,2)-n-1
            data = single(reshape(img(x_loop-round(n/2):x_loop+round(n/2),y_loop-round(n/2):y_loop+round(n/2),:),[(2*round(n/2)+1)^2,z_size]));
            nimg(x_loop,y_loop,:) = int16(median(data,1));
            loop=loop+1;
        end
    end
    
    img = asl_zero_pad_matrix(0,nimg,n);
    
    %progressbar(1);
    
    nii.img = img;
    [d,f,~] = fileparts(ff{l});
    save_nii(nii,fullfile(d,['m',f,'.nii']));
end

end