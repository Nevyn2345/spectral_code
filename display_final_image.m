%Displays the final image

%original_data_cut is the positions of the points
%indfinal is the list of indexes for which we have processed the spectra
%spectra_out is xcorrelation of the spectra


index = 1:size(spectra_out,1);
index = index'
ai = max(spectra_out, [], 2);

ab = index(ai > (1*10^11));

plot(original_data_cut(:,2), original_data_cut(:,3), '.');
hold on

plot(original_data_cut(ab, 2), original_data_cut(ab,3), 'r.');

%%

histogram(ai, 100)

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