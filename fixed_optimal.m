
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
        if any(mrk.y(1, idx_section))
            number_correctness = number_correctness + 1; 
        else
            number_correctness = number_correctness - 1; 
        end
    end
    effective_correctness(i) = number_correctness / number_decisions(i);
    % one section means one decision
    decision_per_minute(i) = double(number_decisions(i))/ellipsed_minutes;
    SPM(i) = decision_per_minute(i) * effective_correctness(i);
end
figure
plot(1:max_i, SPM);
xlabel('number of events in a decision')
ylabel('SPM')
[max_SPM, optimal_fixed] = max(SPM)
decision_per_second = decision_per_minute/60;
decision_per_minute_optimal = decision_per_minute(optimal_fixed)
effective_correctness_optimal = effective_correctness(optimal_fixed)
figure
plot(1:max_i, decision_per_second)
hold on;
plot(1:max_i, effective_correctness)
plot([optimal_fixed optimal_fixed], [0 1], 'r')
legend('decision\_per\_second', 'effective\_correctness');