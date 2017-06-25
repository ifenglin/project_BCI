function [ prediction ] = bci_fixed(outputs, counters, alpha )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    if size(outputs, 2) < alpha
        prediction = 0;
    else
        % make prediction
        accumulated_outputs = sum(outputs, 2);
        idx= find(counters>0);  % avoid divide by zero
        effective_outputs(idx)= accumulated_outputs(idx) ./ counters(idx);
        [max_score, selected_class]= max(effective_outputs);
        % [maxval, argmax] = max(accumulated_outputs);
        if isempty(effective_outputs) || (length(find(accumulated_outputs == max_score))>1)
            prediction = 0;
        else
            prediction = selected_class;
        end
    end
end

