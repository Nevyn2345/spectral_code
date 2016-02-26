function [ Image ] = SS_load_tiff_file( file_path )
%Reads in a multipage TIFF file
%   Detailed explanation goes here

id = 'MATLAB:imagesci:tiffmexutils:libtiffWarning';
warning('off',id);

info = imfinfo(file_path);
num_images = numel(info);
X_width=info.Width;
Y_width=info.Height;

Image=zeros(X_width,Y_width,num_images, 'uint16');

TifLink = Tiff(file_path, 'r');
for Q=1:num_images
    TifLink.setDirectory(Q);
    Image(:,:,Q) = TifLink.read();
end
TifLink.close();

end

