%Shows the real image plus localisations and then the spectral image plus
%the transformed localisations

Frame_number = 100;
% filesr=LM_filelist(Real_path);
% filess=LM_filelist(Spectral_path);
Image_spec = filess;
Image_real = filesr;

Xcol=3;
Ycol=4;
pixel_size = 130;

Real_pointst=csvread(char(Real_points_path),1,0);
Real_points(:,1)=Real_pointst(:,2);
Real_points(:,2:3)=Real_pointst(:,Xcol:Ycol)/pixel_size;
Real_points(:,4)=Real_pointst(:,1);

index=find(Real_points(:,1)==Frame_number);

if index > 0
    [ new_centres ] = transformcent( A,B,Real_points(index,2),Real_points(index,3) );
    spectral_pos=zeros(size(new_centres,1),4);
    spectral_pos(:,2:3)=ceil(new_centres(:,1:2));
    spectral_pos(:,1)=Real_points(index,1);
    spectral_pos(:,4)=Real_points(index,4);
    index2=find(spectral_pos(:,1)==Frame_number);
    Spectral_image=Image_spec(:,:,Frame_number);
    Real_image = Image_real(:,:,Frame_number);
    
    %Plot the real image and points
    subplot(1,2,1)
    imagesc(Real_image);
    axis equal
    axis([0 128 0 128]);
    hold on;
    %colormap('gray');
    plot(Real_points(index,2), Real_points(index,3), 'ro');

    %Plot the spectral image and points
    subplot(1,2,2);
    imagesc(Spectral_image);
    
    %check the boundaries and resize the image
    t = num2cell([0 128 0 128]);
    [minx, maxx, miny, maxy] = deal(t{:});

    if min(spectral_pos(index2,2))-5 < 0
        minx = min(spectral_pos(index2,2))-5;
    end
    if max(spectral_pos(index2,2))+5 > 128
        maxx = max(spectral_pos(index2,2))+5;
    end
    if min(spectral_pos(index2,3))-5 < 0
        miny = min(spectral_pos(index2,3))-5;
    end
    if max(spectral_pos(index2,3))+5 > 128
        maxy = max(spectral_pos(index2,3))+5;
    end            
    axis equal
    axis([minx maxx miny maxy]);

    hold on;
    %colormap('gray');
    plot(spectral_pos(index2,2), spectral_pos(index2,3), 'g*');
else
    disp('No Points found in this frame')
end
        