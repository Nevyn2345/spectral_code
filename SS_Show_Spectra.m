function [  ] = SS_Show_Spectra( Spectra_out, Storage, summed, single,spectra,double)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
figure;
if summed > 0
    subplot(1,2,1);
    temp=sum(Storage,3);
    temp2 = sum(Storage,3);
    imagesc(temp2);
    axis equal
    axis tight
    subplot(1,2,2);
    x = 1:size(Storage,1);
    cs = spline(x,[0 sum(temp2,2).' 0]);
    xx = linspace(0,size(Storage,1),101);
    plot(xx,ppval(cs,xx),'-');
    hold on
    plot(sum(temp2,2), 'r');
else
if length(single) > 25 %take the first 25 spectra
    single=single(1:25);
end
if length(single) ~=0
   if length(single) > 4 && length(single) <9 
    for i=1:length(single)
        subplot(3,3,i);
        test=sum(Storage(:,:,single(i)),2);
        plot(test);
        hold on;
        if spectra ==1
            x=1:length(Storage(:,:,single(1)));
            if double ==1
            f=  Spectra_out(i,4)+Spectra_out(i,1).*exp(-((x-Spectra_out(i,2))/Spectra_out(i,3)).^2)+Spectra_out(i,5).*exp(-((x-Spectra_out(i,6))/Spectra_out(i,7)).^2);
            plot(f); 
            else
            f=  Spectra_out(i,1).*exp(-((x-Spectra_out(i,2))/Spectra_out(i,3)).^2) + Spectra_out(i,4);
            plot(f);
            end
        end
        hold off;
    end
   end
   
   if length(single) >= 2 && length(single) <=4 
 
    for i=1:length(single)
        subplot(2,2,i);
        test=sum(Storage(:,:,single(i)),2);
        plot(test);
        hold on;
        if spectra ==1
            x=1:length(Storage(:,:,single(1)));
            if double ==1
            f=  Spectra_out(i,4)+Spectra_out(i,1).*exp(-((x-Spectra_out(i,2))/Spectra_out(i,3)).^2)+Spectra_out(i,5).*exp(-((x-Spectra_out(i,6))/Spectra_out(i,7)).^2);
            plot(f); 
            else
            f=  Spectra_out(i,1).*exp(-((x-Spectra_out(i,2))/Spectra_out(i,3)).^2) + Spectra_out(i,4);
            plot(f);
            end
        end
        hold off;
    end
   end
   
   if length(single) > 9  
    for i=1:length(single)
        subplot(5,5,i);
        test=sum(Storage(:,:,single(i)),2); %plots the spectra as the sum through perpendicular to the spectrum
        plot(test);
        hold on;
        if spectra ==1
            x=1:length(Storage(:,:,single(1)));
            if double ==1
                f=  Spectra_out(i,4)+Spectra_out(i,1).*exp(-((x-Spectra_out(i,2))/Spectra_out(i,3)).^2)+Spectra_out(i,5).*exp(-((x-Spectra_out(i,6))/Spectra_out(i,7)).^2);
                plot(f); 
            else
                f=  Spectra_out(i,1).*exp(-((x-Spectra_out(i,2))/Spectra_out(i,3)).^2) + Spectra_out(i,4);
                plot(f);
            end
        end
    end
   end
   
   if length(single) == 1  
    for i=1:length(single)
        test=sum(Storage(:,:,single(i)),2);
        plot(test);
    end
   end
   
  
end

end



end

