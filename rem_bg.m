
points2 = [0 0 0 0 0];
newS = zeros(51,11);
for I = 1:size(Storage,3)
    I
    xpos = datar(I,2);
    ypos = datar(I,3);
    [ xtrans, ytrans] = transformPointsInverse(tform, xpos, ypos);
    if datar(I,1) > 6
        points2 = datar(datar(:,1)> datar(I,1)-6 & datar(:,1) < datar(I,1) + 6,:);
        
        range = (datar(I,1)-5:datar(I,1)+5)';
        lia = ismember(range,points2(:,1));
        
        empties = range(~lia);
        if length(empties) > 0
            xposs = ceil(xtrans);
            yposs = ceil(ytrans);
            a = (Images(xposs - xcut:xposs + xcut,yposs - ycut:yposs + ycut,empties(1)))';
            a1 = im2double(a, 'indexed');
            newS(:,:,end+1) = Storage(:,:,I) - a1;
        end
    end
    
    
%     
%     xv = [xpos - xcut/2, xpos - xcut/2, xpos + xcut/2, xpos + xcut/2];
%     yv = [ypos - ycut/2, ypos + ycut/2, ypos - ycut/2, ypos + ycut/2];
%     [in, on ] = ~inpolygon(points2(:,2),points2(:,3), xv, yv);
end