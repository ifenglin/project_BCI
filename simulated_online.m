clear
%% set up data

% file paths
basename= '2014ss-BCIPJ-Team2-calibration';
filename = 'VPras';
file = strcat('bci_demo_data\data\VPras_14_09_02\', basename, filename) ;
% filename = 'VPrah';
% file = strcat('bci_demo_data\data\VPrah_14_07_14\', basename, filename) ;

% methods
method=@bci_t_test;
method_name = 't_test';
alpha = 0.025;
% method=@bci_fixed;
% method_name = 'fixed';
% alpha = 20;

hdr= file_readBVheader(file);
% define low-pass filter
Wps= [40 49]/hdr.fs*2;
[n, Ws]= cheb2ord(Wps(1), Wps(2), 3, 50);
[filt.b, filt.a]= cheby2(n, 50, Ws);

% the following applies the low-pass filter to the data in original sampling
% frequency, and then subsamples signals at 100 Hz
[cnt, vmrk]= file_readBV([file '*'], 'Fs',100, 'Filt',filt);

classDef= {[61:86], [1:25, 31:56]; 'target', 'nontarget'};
mrk= mrk_defineClasses(vmrk, classDef);

mnt= mnt_setElectrodePositions(cnt.clab);
mnt= mnt_setGrid(mnt, 'M');

%% simulated online
prediction = 0;
prediction_hist = zeros(length(mrk.time), 1);
class_count = zeros(10,1);
idx_start = 1;
for i = 1:length(mrk.time) % time
    if prediction ~= 0
        prediction = prediction; 
        class_count(prediction) = class_count(prediction) + 1;
        idx_start = i;
    end
    idx_section = idx_start:i;
    desc_in_section = mrk.event.desc(idx_section);
    [~, outputs] = desc_decoder(desc_in_section);
    %prediction = bci_t_test(outputs, alpha);
    %prediction = bci_fixed(outputs);
    prediction = method(outputs, alpha);
    prediction_hist(i) = prediction;
end
plot(1:length(mrk.time), prediction_hist, '*');
ylim([1, 10])
title(strcat('Predictions through Time ', filename, ' ', method_name));
xlabel('time [ms]')
ylabel('prediction')
saveas(gcf, strcat('prediction_through_time_', filename, '_', method_name, '.png'));
figure
bar(class_count)
title(strcat('Number of prediction by class ', filename, ' ', method_name));
xlabel('Class')
ylabel('Number of prediction')
saveas(gcf, strcat('prediction_by_class_', filename, '_', method_name, '.png'));