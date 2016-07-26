function [ bestfit ] = SS_fit( Image )
%Takes a 3D matrix of images and fits a gaussian function to each one,
%returning the parameters for each fit


[Xs,Ys]=size(Image);

XY = Xs;
[X,Y]=meshgrid(1:XY,1:XY); %your x-y coordinates
x(:,1)=X(:); % x= first column
x(:,2)=Y(:); % y= second column 
fits  = [];


Z=reshape(Image,Xs,Xs);
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
guesses=[max(max(Image)),Xs/2,3,Xs/2,3,min(min(Image))];


[bestfit,~,~,~]=lsqcurvefit(@Gaussian2D,guesses,x,Z(:),lower,upper,options);


%fits=[];

end

