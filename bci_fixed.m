function [ prediction ] = bci_fixed( Data, alpha )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
    if length(Data) < alpha
        prediction = 0;
    else
        % make prediction
        accumulated_outputs = sum(Data, 2);
        [maxval, argmax] = max(accumulated_outputs);
        if (length(find(accumulated_outputs==maxval))>1)
            prediction = 0;
        else
            prediction = argmax;
        end
    end
end

