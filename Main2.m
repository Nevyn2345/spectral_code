%Main 
%% CSV DATA FORMAT ' ID ' ' Frame ' ' XNM ' ' YNM ' ' Intensity ' ' offset '
%%% CUT OUT SPECTRA


cut_x=5;                                                %width of Spectra
cut_y=25;                                               %Hieght of Spectra

if exist('Path', 'var') == 1
    [filename, Path] = uigetfile('*.tif', 'Select Real File', Path);
else
    [filename, Path] = uigetfile('*.tif', 'Select Real File');
end
Real_path = strcat(Path,filename);
[filename, Path2] = uigetfile('*.tif', 'Select Spectra File', Path);
Spectral_path = strcat(Path2,filename);
[filename, Path] = uigetfile('*.csv', 'Select Localisation File', Path);
Real_points_path = strcat(Path,filename);

load('points.mat');
tform = fitgeotrans([gspec(:,3) gspec(:,4)], [g(:,3) g(:,4)], 'affine');

Imager = SS_load_tiff_file(Real_path);
Images = SS_load_tiff_file(Spectral_path);

pixel_size=130;                                         % Size of Pixels in nm if data in pixels set to 1.

disp('Spectra loaded');
%Data should be in the format

spatial_filter=1;
load('centre_points.mat')
XYcentre=final_pos;

radius=200;
%%
[ Storage, Remember_ID,debugg_data,original_data_cut, index, datar ] = SS_collect_spectra( tform, Imager,Images,Real_points_path,cut_x,cut_y,pixel_size,spatial_filter,XYcentre,radius);
%%
%%%%%%%%%%%%%%%%%%%%%%%
%Remove Background
[ Storage ] = SS_remove_background( Storage );
%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%
%%% FILTER SPECTRA PRE FIT

SNR=1;            % Signal to noise
difference=20000;    % Difference from first point to final final
average_length=5;   % length of averaging for first and final points
centred =0;         % is the main peak near the middle (will depend on cut_y

[ indfinal ] = SS_Filter_spectra(Storage, difference, average_length,SNR,centred );
indfinal = 1:size(Storage,3);
disp('Spectra Pre filtered');
Bunny=['Selected ',num2str(length(indfinal))];
disp(Bunny);
Bunny=['Out of ',num2str(length(Storage))];
disp(Bunny);
%%
%%%%%%%%%%%%%%%%%%%%%%%%
%%% Fit spectra
load('fitdata647.mat');
interpo=1;
division_number=20; 
                                      % cut points
double_fit=0;                       % double gaussian 
plot_data=0;                        % Plot it
new_Storage=Storage(:,:,indfinal);  %select only filtered spectra
[ spectra_out,resn ] = SS_Fit_Spectra( Storage, cut_y,double_fit, plot_data, Remember_ID );
%[ spectra_out, resn ] = SS_fit_spectral( new_Storage,cut_y)
%Doesn't actually get the spectra, but rather shows the xcrorrelation with
%fitdata
%[ spectra_out ] = SS_Xcorr_fit( new_Storage,fitdata,interpo,division_number );
disp('Spectra fitted');

%%%%%%%%%%%%%%%%%%%%%%
%%%% show the spectra
%%
summed=1;               %all the data
single=indfinal;        % just the filtered dat
spectra=1;              % show the fitted data
double=0;               % is it double or single

SS_Show_Spectra( spectra_out, Storage, summed, single, spectra, double);