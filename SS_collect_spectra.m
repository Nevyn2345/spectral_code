function [ Storage, Remember_ID,debugg_data,original_data_cut, index ] = SS_collect_spectra( A1,B1,Real_path,Spectral_path,Real_points_path,cut_x,cut_y,pixel_size,spatial_filter,XYcentre,radius)

%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
widthcut=128; % 256
Xcol=3;
Ycol=4;
pathr=Real_path;
%filesr=LM_filelist(Real_path);
filesr = SS_load_tiff_file(Real_path);
paths=Spectral_path;
%filess=LM_filelist(Spectral_path);
filess = SS_load_tiff_file(Spectral_path);


Real_pointst=csvread(char(Real_points_path),1,0);
Real_points(:,1)=Real_pointst(:,2);
Real_points(:,2:3)=Real_pointst(:,Xcol:Ycol)/pixel_size;
Real_points(:,4)=Real_pointst(:,1);

position=1;
%spatial_filter only takes points from winin a certain area, presumably for
%limiting the spherical abberations?
if spatial_filter==1;
    for I=1:length(Real_points);
        if sqrt(((Real_points(I,2)-XYcentre(1,1)).^2)+((Real_points(I,3)-XYcentre(1,2)).^2))<radius
          temp_index_points(position)=I;
          position=position+1;
        end
    end
    Real_pointsa=Real_points(temp_index_points,:);
    original_data_cut=Real_pointsa;
    clear Real_points;
    Real_points=Real_pointsa;
end
    






Remember_ID=0;
debugg_data(1,1)=0;
%debugg_data(1,2)=0;
Storage=zeros((2*cut_y)+1,(2*cut_x)+1,length(Real_points));
position=1;
for Frame_number=1:length(filesr)-1
    disp(Frame_number);
    index=find(Real_points(:,1)==Frame_number);
    if index >0
        %obtain spectral centre points based on calibration
        [ new_centres ] = transformcent( A1,B1,Real_points(index,2),Real_points(index,3) );
        spectral_pos=zeros(size(new_centres,1),4);
        spectral_pos(:,2:3)=ceil(new_centres(:,1:2));
        spectral_pos(:,1)=Real_points(index,1);
        spectral_pos(:,4)=Real_points(index,4);
        holdit=index;

        %Spectra_image=imread(char(filess(Frame_number)));
        Spectra_image=filess(:,:,Frame_number);
        for Point_number=1:size(new_centres,1)
            holdit=spectral_pos(Point_number,2)<widthcut-cut_y && spectral_pos(Point_number,3)<widthcut-cut_y;
            debugg_data=[debugg_data;holdit];
            if spectral_pos(Point_number,2)<widthcut-cut_y && spectral_pos(Point_number,3)<widthcut-cut_y;
                %Make sure values are positive
                if spectral_pos(Point_number,3)-cut_y > 0 && spectral_pos(Point_number,3)+cut_y > 0 && spectral_pos(Point_number,2)-cut_x > 0 &&spectral_pos(Point_number,2)+cut_x > 0;
                    Storage(:,:,position)=Spectra_image(spectral_pos(Point_number,3)-cut_y:spectral_pos(Point_number,3)+cut_y,spectral_pos(Point_number,2)-cut_x:spectral_pos(Point_number,2)+cut_x);
                    %Remember_ID(position)=Real_points(index(Point_number),1);
                    Remember_ID(position)=spectral_pos(Point_number,4);
                    position=position+1;
                end
            end
        end
    
    
    end
    
    
    
end
%original_data_cut=0;
Storage=Storage(:,:,1:position-1);
%Storage=Storage(:,:,1:end);
end

