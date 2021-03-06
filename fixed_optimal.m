clear
%% set up data
basename= '2014ss-BCIPJ-Team2-calibration';

filename = 'VPras';
file = strcat('bci_demo_data\data\VPras_14_09_02\', basename, filename) ;
% filename = 'VPrah';
% file = strcat('bci_demo_data\data\VPrah_14_07_14\', basename, filename) ;

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

%% fixed optimal 

delta_t = 200;
max_i = 100;
ellipsed_minutes = ((mrk.time(end)-mrk.time(1))/1000/60);

% initialization for speed-up
effective_correctness = zeros(max_i, 1);
SPM = zeros(max_i, 1);
decision_per_minute = zeros(max_i, 1);
number_decisions = zeros(max_i, 1);

for i = 1:max_i % i: proposed optimal value
    number_correctness = 0;
    number_decisions(i) = floor(size(mrk.y, 2)/i);
    for j = 1: number_decisions(i) % j: iterator for each decision        
        % the indicies of a decision;
        % to avoid out-of-range error, the last parts are removed
        % if they are not enough for a decision.
        idx_section = 1 + (j-1)*i : j*i;
        
        % +1 if a decision contains any classified targets (correct,)
        % -1 if a decision contains no classified targets (wrong.)
        targets_in_section = find(mrk.y(1,idx_section)); 
        desc_in_section = mrk.event.desc(idx_section);
        if any(targets_in_section)
            targets_desc = desc_in_section(targets_in_section);
            [outputs, counters] = desc_decoder(targets_desc);
            accumulated_outputs = sum(outputs, 2);
            maxval = max(accumulated_outputs);
            maxidx = find( accumulated_outputs==maxval );
            if length(maxidx) == 1
                number_correctness = number_correctness + 1; 
            else
                number_correctness = number_correctness - 1; 
            end
        else
            number_correctness = number_correctness - 1; 
        end
    end
    effective_correctness(i) = number_correctness / number_decisions(i);
    % one section means one decision
    decision_per_minute(i) = double(number_decisions(i))/ellipsed_minutes;
    SPM(i) = decision_per_minute(i) * effective_correctness(i);
end
[max_SPM, optimal_fixed] = max(SPM)
decision_per_second = decision_per_minute/60;
decision_per_minute_optimal = decision_per_minute(optimal_fixed)
effective_correctness_optimal = effective_correctness(optimal_fixed)
figure
plot(1:max_i, SPM);
hold on
plot([optimal_fixed optimal_fixed], [max_SPM-100 max_SPM+100], 'r')
title(strcat(filename, ' SPM'));
xlabel('number of events in a decision')
ylabel('SPM')
saveas(gcf, strcat(filename, '_SPM.png'))
figure
plot(1:max_i, decision_per_second)
hold on;
plot(1:max_i, effective_correctness)
plot([optimal_fixed optimal_fixed], [-1 2], 'r')
title(strcat(filename, ' Fixed Optimal Curves'));
xlabel('number of events in a decision')
saveas(gcf, strcat(filename, '_curves.png'))
legend('decision\_per\_second', 'effective\_correctness');