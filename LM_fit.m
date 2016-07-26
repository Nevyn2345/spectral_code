function [ params ] = LM_fit( extract )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    extract = im2double(extract, 'indexed');
    ex_dim=size(extract,1);
    
    %scale extract so intensities are roughly on a range of 0 to the dimensions of the region
    %this makes the problem "well scaled": all variables vary within
    %similar ranges
    
    raw_ex_max=max(max(extract));
    
    extract=(extract./raw_ex_max).*ex_dim;
     
    ex_max=max(max(extract));
    ex_min=min(min(extract));
    ex_av=mean(mean(extract));
       
    
    %set up variables for fitting
    XY=ex_dim;
    [X,Y]=meshgrid(1:XY,1:XY); %your x-y coordinates
    x(:,1)=X(:); % x= first colun
    x(:,2)=Y(:); % y= second column
            
    lower=[0 0 0 0 0 0];
    guesses=[ex_max ex_dim/2 ex_dim/2 ex_dim/2 ex_dim/2 ex_min];
    upper=[ex_max*2 ex_dim ex_dim ex_dim ex_dim ex_min*2];
        
    %options=optimset('Display','off');
    options=optimoptions('lsqcurvefit','Jacobian','on','Display','off','TolFun',1e-6);
    [bestfit,resn,~,ef]=lsqcurvefit(@Gaussian2DJ,guesses,x,extract(:),lower,upper,options);
        
    %scale intensity and background values back to normal    
    bestfit(1)=(bestfit(1)/ex_dim)*raw_ex_max;
    bestfit(6)=(bestfit(6)/ex_dim)*raw_ex_max;
    
    params=[bestfit resn ef];
    
    %extractspline=interp2(extract,3,'cubic');
    
    %per fit diagnostics
    %{
    hold on
    
        imagesc(extract);
        set(gca,'DataAspectRatio',[1 1 1]);
        set(gca,'YDir','reverse')
        scatter(bestfit(:,2),bestfit(:,4));
    
    hold off
    %} 
end

