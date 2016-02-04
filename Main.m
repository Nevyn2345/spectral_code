%Main 
%% CSV DATA FORMAT ' ID ' ' Frame ' ' XNM ' ' YNM ' ' Intensity ' ' offset '
%%% CUT OUT SPECTRA

%

cut_x=3;                                                %width of Spectra
cut_y=9;                                               %Hieght of Spectra
%load('/Users/Ashley/Desktop/Sams/transforms.mat');      %A and B matricies
load('/Users/Ashley/Desktop/Sams-Final/ABmat.mat')
Real_path='/Users/Ashley/Desktop/spectral_Data/realout';            %Real Images (not really needed)
Spectral_path='/Users/Ashley/Desktop/spectral_Data/specoutf';     %Spectra Images NEEDED
Real_points_path='/Users/Ashley/Desktop/Sams-Final/Real-fits.csv';
% Points identifies using external code

%load('/Users/Ashley/Desktop/Sams/transforms.mat');      %A and B matricies
%load('/Users/Ashley/Desktop/Sams-Final/ABmat.mat')
%Real_path='/Users/Ashley/Desktop/spectral_Data/cali_real';            %Real Images (not really needed)
%Spectral_path='/Users/Ashley/Desktop/spectral_Data/cali_spec';     %Spectra Images NEEDED
%Real_points_path='/Users/Ashley/Desktop/spectral_Data/cali_real.csv';
% Points identifies using external code

pixel_size=130;                                         % Size of Pixels in nm if data in pixels set to 1.

disp('Spectra loaded');
%Data should be in the format

Starting_point=csvread(char(Real_points_path),1,0);
Starting_point(:,1)=Starting_point(:,3);
Starting_point(:,2)=Starting_point(:,4);
Starting_point(:,1:2)=Starting_point(:,1:2)/pixel_size;




spatial_filter=1;
load('centre_points.mat')
XYcentre=final_pos;

radius=50;

[ Storage, Remember_ID,debugg_data,original_data_cut ] = SS_collect_spectra( A,B,Real_path,Spectral_path,Real_points_path,cut_x,cut_y,pixel_size,spatial_filter,XYcentre,radius);

%%%%%%%%%%%%%%%%%%%%%%%
%Remove Background
[ Storage ] = SS_remove_background( Storage );
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%
%%% FILTER SPECTRA PRE FIT

SNR=2;            % Signal to noise
difference=20000;    % Difference from first point to final final
average_length=5;   % length of averaging for first and final points
centred =0;         % is the main peak near the middle (will depend on cut_y

[ indfinal ] = SS_Filter_spectra(Storage, difference, average_length,SNR,centred );
disp('Spectra Pre filtered');
Bunny=['Selected ',num2str(length(indfinal))];
disp(Bunny);
Bunny=['Out of ',num2str(length(Storage))];
disp(Bunny);

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fit spectra
load('fitdata.mat');
interpo=1;
division_number=20;
                                      % cut points
double_fit=0;                       % double gaussian 
plot_data=0;                        % Plot it
new_Storage=Storage(:,:,indfinal);  %select only filtered spectra
%[ spectra_out,resn ] = SS_Fit_Spectra( new_Storage, cut_y,double_fit, plot_data );
%[ spectra_out, resn ] = SS_fit_spectral( new_Storage,cut_y)
[ spectra_out ] = SS_Xcorr_fit( new_Storage,fitdata,interpo,division_number );
disp('Spectra fitted');

%%%%%%%%%%%%%%%%%%%%%%
%%%% show the spectra

summed=0;               %all the data
single=indfinal;        % just the filtered dat
spectra=1;              % show the fitted data
double=0;               % is it double or single

SS_Show_Spectra( spectra_out, Storage, summed, single, spectra, double);