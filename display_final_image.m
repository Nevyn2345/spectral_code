%Displays the final image

%original_data_cut is the positions of the points
%indfinal is the list of indexes for which we have processed the spectra
%spectra_out is xcorrelation of the spectra

index = 1:size(Storage,3);
spectra_out(:,5) = 1:size(spectra_out,1);
index = index';
temp = sum(Storage, 2);
[~, ai] = max(temp, [], 1);
disp('dgfgd')
spectra_outf2 = [];
spectra_outf3 = [];
spectra_outf = [];
% %spectra_out(:,5) = Remember_ID';
spectra_outf(:,:) = spectra_out(spectra_out(:,3)<6.9,:);
spectra_outf2(:,:) = spectra_outf(spectra_outf(:,3) > 2.1,:);
% %spectra_outf2(:,:) = spectra_outf3(spectra_outf3(:,1) > 10000,:);
ab = spectra_outf2(:,2) > 30;
specf = spectra_out(ab,:);
disp('dgfgd2')
%ab = index(ai > (10));

figure

plot(datar(spectra_out(:,5),2), datar(spectra_out(:,5),3), '.', 'MarkerSize', 5);
hold on
plot(datar(specf(:,5), 2), datar(specf(:,5),3), 'r.', 'MarkerSize',5);

%%

histogram(ai)

%% plot spectra

for i=1:25
    subplot(5,5,i)
    plot(spectra_out(i,:))
end

%%
index = 1:size(spectra_out,1);
index = index'
ai = index(spectra_out(:,1)>0);

%ab = index(ai > (1*10^11));

plot(original_data_cut(:,2), original_data_cut(:,3), '.');
hold on

plot(original_data_cut(ai, 2), original_data_cut(ai,3), 'r.');