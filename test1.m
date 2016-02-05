%Paths
%path_spec='/Users/Ashley/Dropbox/Work/MAtlab Work/Spectral Storm Code/MultipointABcalibration/calibration_3sf.tif';
%path_real='/Users/Ashley/Dropbox/Work/MAtlab Work/Spectral Storm Code/MultipointABcalibration/calibration_3r.tif';
slash = LM_osslash();

path_real=strcat('Data', slash, 'Realc.tif');
path_spec=strcat('Data', slash, 'Specc.tif');

%Images
[ Image_real ] = SS_load_tiff_file(path_real);
[ Image_spec ] = SS_load_tiff_file(path_spec);

% cut widths
real_cut=3;
X_spec_cut=7;
Y_spec_cut=3;

[height, width, dim] = size(Image_real);


subplot(1,2,1);
imagesc(Image_real(:,:,1));
axis equal
axis([0 height 0 width])
subplot(1,2,2);
imagesc(Image_spec(:,:,1));
axis equal
axis([0 height 0 width])

[x,y] = ginput(6);
X1=floor(x(1:2:end));
X2=floor(x(2:2:end));
Y1=floor(y(1:2:end));
Y2=floor(y(2:2:end));


%Cut out the selected areas of the image
clear real_section;
for Q=1:3
real_section(:,:,Q)=Image_real(Y1(Q)-real_cut:Y1(Q)+real_cut,X1(Q)-real_cut:X1(Q)+real_cut);
end
clear spec_section;
for Q=1:3
spec_section(:,:,Q)=Image_spec(Y2(Q)-X_spec_cut:Y2(Q)+X_spec_cut,X2(Q)-Y_spec_cut:X2(Q)+Y_spec_cut);
end

for Q=1:3
    %real
    temp=real_section(:,:,Q);
    %work out position of max value in cut 'b'
    [a,b]=max(temp(:));
    %find x,y position of max value at 'b'
    [x,y] = ind2sub(size(temp),b);
    final_points(Q,2)=x+Y1(Q)-real_cut-1;
    final_points(Q,1)=y+X1(Q)-real_cut-1;
    
    %spec
    temp=spec_section(:,:,Q);
    [a,b]=max(temp(:));
    [x,y] = ind2sub(size(temp),b);
    final_points(Q,3)=x+X2(Q)-X_spec_cut-1;
    final_points(Q,4)=y+Y2(Q)-Y_spec_cut-1;
   
end

subplot(1,2,1);
imagesc(Image_real(:,:,1));
hold on;
for Q=1:3
    plot(final_points(Q,1),final_points(Q,2),'y*');
end
    
subplot(1,2,2);
imagesc(Image_spec(:,:,1));
hold on;
for Q=1:3
    plot(final_points(Q,3),final_points(Q,4),'y*');
end
    

[ final, A,B ] = TranslateCalibration([final_points(:,1) final_points(:,2)],[final_points(:,3) final_points(:,4)], 1, [1 2 3], [1 2 3] );


