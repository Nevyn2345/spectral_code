
[filename, Path] = uigetfile('*.tif');
path_real = strcat(Path,filename);
[filename, Path] = uigetfile('*.tif', 'Select Calibration Spectra', Path);
path_spec = strcat(Path,filename);

%Images
[ Calibration_real ] = SS_load_tiff_file(path_real);
[ Calibration_spec ] = SS_load_tiff_file(path_spec);

% cut widths
real_cut=3;
X_spec_cut=7;
Y_spec_cut=3;

[height, width, dim] = size(Calibration_real);

cal_frame = 1;
imsize = size(Calibration_real, 2);

subplot(1,2,1);
imagesc(Calibration_real(:,:,cal_frame));
axis equal
axis([0 height 0 width])
subplot(1,2,2);
imagesc(Calibration_spec(:,:,cal_frame));
axis equal
axis([0 height 0 width])

npoints = 7;

[x,y] = ginput(npoints*2);
X1=floor(x(1:2:end)); %real vals
X2=floor(x(2:2:end)); %spec vals
Y1=floor(y(1:2:end));
Y2=floor(y(2:2:end));

%%
%Cut out the selected areas of the image
clear real_section;
for Q=1:npoints
    real_section(:,:,Q)=Calibration_real(Y1(Q)-real_cut:Y1(Q)+real_cut,X1(Q)-real_cut:X1(Q)+real_cut, cal_frame);
end
clear spec_section;

[mismatchymin, mismatchymax, mismatchxmin, mismatchxmax] = deal(0);

spec_section = zeros( X_spec_cut*2+1,Y_spec_cut*2+1, npoints);

for Q=1:npoints
    if Y2(Q)-X_spec_cut <= 0
        mismatchymin = abs(Y2(Q)-X_spec_cut)+1;
    elseif Y2(Q)+X_spec_cut > imsize
        mismatchymax = (Y2(Q)+X_spec_cut) - imsize;
    elseif X2(Q)-Y_spec_cut <= 0
        mismatchxmin = abs(X2(Q)-Y_spec_cut) + 1;
    elseif X2(Q)+Y_spec_cut > imsize
        mismatchxmax = X2(Q)+Y_spec_cut - imsize;
    end
    spec_left =Y2(Q)-X_spec_cut + mismatchymin;
    spec_right = Y2(Q)+X_spec_cut - mismatchymax;
    spec_top = X2(Q)-Y_spec_cut + mismatchxmin;
    spec_bottom = X2(Q)+Y_spec_cut - mismatchxmax;
    spec_section(1:spec_right-spec_left+1,1:spec_bottom-spec_top+1,Q)=Calibration_spec(spec_left:spec_right,spec_top:spec_bottom,cal_frame)
end
%%


options=optimset('Display','off','TolFun',1e-8,'TolX',1e-8,'MaxFunEvals',500);

%First is scaling
%Second is X pos
%Third is X width
%Fourth is Y pos
%Fith os Y width
%6 is offset

lower=[1,1,1,1,1,0];
%The widths need to be better done

upper=[1000,Xs,1000,Xs,1000,1000];
guesses=[max(max(Image)),Xs/2,3,Xs/2,3,min(min(Image_stack(:,:,point_to_use)))];


[bestfit,~,~,~]=lsqcurvefit(@Gaussian2D,guesses,x,Z(:),lower,upper,options);

fits = [fits; bestfit];




for Q=1:npoints
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
    holdtest(Q,1) = x;
    holdtest(Q,2) = y;
    final_points(Q,3)=X2(Q) + y -Y_spec_cut-1; %90 + 4 - 3 - 1
    final_points(Q,4)=Y2(Q)+ x -X_spec_cut-1; %69 + 8 - 7 - 1 
   
end

subplot(1,2,1);
imagesc(Calibration_real(:,:,cal_frame));
hold on;
for Q=1:npoints
    plot(final_points(Q,1),final_points(Q,2),'y*');
end
    
subplot(1,2,2);
imagesc(Calibration_spec(:,:,cal_frame));
hold on;
for Q=1:npoints
    plot(final_points(Q,3),final_points(Q,4),'b*');
end
    

tform = fitgeotrans([final_points(:,3) final_points(:,4)], [final_points(:,1) final_points(:,2)], 'projective')

[ xtrans, ytrans] = transformPointsInverse(tform, final_points(:,1), final_points(:,2));

plot( xtrans, ytrans, 'ro')

%[ final, A,B ] = TranslateCalibration([final_points(:,1) final_points(:,2)],[final_points(:,3) final_points(:,4)], 1, [1 2 3], [1 2 3] );


