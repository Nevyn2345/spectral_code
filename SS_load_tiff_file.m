function [ Image ] = SS_load_tiff_file( file_path )
%Reads in a multipage TIFF file
%   Detailed explanation goes here

info = imfinfo(file_path);
num_images = numel(info);
X_width=info.Width;
Y_width=info.Height;

Image=zeros(X_width,Y_width,num_images);
for Q=1:num_images
Image(:,:,Q) = imread(file_path,Q);
end


end

