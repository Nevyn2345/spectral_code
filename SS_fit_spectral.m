function [ spectra_out,resn ] = SS_fit_spectral( Storage,cut_y,Remember_ID)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

number_points=size(Storage,3);

x=linspace(1,(2*cut_y)+1,(2*cut_y)+1)';
max_width=10;
min_width=2;
centre_start=cut_y;
start_width =10;
startwidth = 4;

%out = zeros(size(number_points), 5);
parfor k=1:number_points

    % fit is    C1 = scale 1
    %           C2 = Centre 1
    %           C3 = width 1
    %           C4 = offset
    
   
    C=[0,10];
    Cupper=[100,1000];
  
    Clower=[-177310,0.001];
    out = zeros(1,5)
    options=optimoptions('lsqcurvefit','Display','off','TolFun',1e-9);
    [out(1:4),resn(k,:),~,ef(k,:)]=lsqcurvefit(@spectrafit,C,x,sum(Storage(:,:,k),2),Clower,Cupper,options);
    out(5) = Remember_ID(k);
    out2(k, :) = out;
end
spectra_out=out2;
end

