
function map_out = asl_zero_pad_matrix(in_out,map,fill_num)

size_map = [size(map,1), size(map,2)];
if (in_out == 1)
    size_new_map=[size_map + 2*fill_num, size(map,3)];
    map_out=zeros(size_new_map,class(map));
   for z=1:size(map,3)
        map_out(1+fill_num:size_map(1)+fill_num,1+fill_num:size_map(2)+fill_num,z)=map(:,:,z);
   end
else
    size_new_map=[size_map - 2*fill_num, size(map,3)];
    map_out=zeros(size_new_map,class(map));
    for z=1:size(map,3)
        map_out(:,:,z)=map(1+fill_num:size_new_map(1)+fill_num,1+fill_num:size_new_map(2)+fill_num,z);
    end
end
end