function [ fitsd ] = drift( fits )
%Drift correction from ThunderSTORM's drift output
  %Fits is the localisations, column 2 = x, column 4 = y, column Z = frame
  %First save the drift FROM THE GRAPH, then open it in excel and resave
  %it as a .csv


[filename, Path] = uigetfile('*.csv');
file = strcat(Path,filename);

drift = csvread(file,1,0);
difference = round(drift(2,5)-drift(1,5));

fitsd = fits;
for i = 1:size(fits,3)
    x(i) = fits(i,2) + drift(round(fits(blah,i)/difference),5);
    y(i) = fits(i,4) + drift(round(fits(blah,i)/difference),7);
end

fitsd(:,2) = x;
fitsd(:,4) = y;


end

