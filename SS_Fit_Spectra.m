function [ spectra_out,resn ] = SS_Fit_Spectra(Storage, cut_y,double_fit, plot_data, Remember_ID)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
number_points=size(Storage,3);
double=double_fit;

%holdall1=zeros(3,1);
%holdall2=zeros((2*cut_y)+1,1);
%for j=1:number_points
%    holdall1=holdall1+(sum(Storage(:,:,j),1)');
%    holdall2=holdall2+(sum(Storage(:,:,j),2));
%end


%x = lsqcurvefit(fun,x0,xdata,ydata)

x=linspace(1,(2*cut_y)+1,(2*cut_y)+1)';
max_width=10;
min_width=2;
centre_start=cut_y;
start_width =10;
startwidth = 4;


parfor k=1:number_points

    % fit is    C1 = scale 1
    %           C2 = Centre 1
    %           C3 = width 1
    %           C4 = offset
    
    if double == 1    
    C=[max(sum(Storage(:,:,k),2)) centre_start start_width min(sum(Storage(:,:,k),2)) max(sum(Storage(:,:,k),2)) centre_start start_width ];
    
    %Cupper=[max(sum(Storage(:,:,k),2))*2 15 max_width min(sum(Storage(:,:,k),2))*2 max(sum(Storage(:,:,k),2))*2 15 max_width];
    Cupper=[10000 15 1000 10000000 10000000 100 100];
    %Clower=[max(sum(Storage(:,:,k),2))/2 1 min_width min(sum(Storage(:,:,k),2))/2 max(sum(Storage(:,:,k),2))/2 1 min_width];
    Clower=[0 1 0 0 1 1 0];
    options=optimoptions('lsqcurvefit','Display','none','TolFun',1e-8);
    [out(k,:),resn(k,:),~,ef(k,:)]=lsqcurvefit(@Gaussian1D2,C,x,sum(Storage(:,:,k),2),Clower,Cupper,options);    

    else
    C=[max(sum(Storage(:,:,k),2)/2) centre_start startwidth min(sum(Storage(:,:,k),2))];
    Cupper=[max(sum(Storage(:,:,k),2))*2 cut_y*2 max_width min(sum(Storage(:,:,k),2))*2];
   % Cupper=[10000 15 1000 10000000 10000000 100 100];
    Clower=[max(sum(Storage(:,:,k),2))/2, 0, min_width, min(sum(Storage(:,:,k),2))/2];
   % Clower=[0 1 0 0 1 1 0];
    options=optimoptions('lsqcurvefit','Display','off','TolFun',1e-9);
    out = zeros(1,5)
    [out(1:4),resn(k,:),~,ef(k,:)]=lsqcurvefit(@Gaussian1D,C,x,sum(Storage(:,:,k),2),Clower,Cupper,options);
    out(5) = Remember_ID(k)
    out2(k,:) = out;
    end


    
end
if plot_data==1;
hist(out2(:,2),30);
end
spectra_out=out2;
end

