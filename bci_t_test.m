function [ prediction ] = bci_t_test( outputs, counters, alpha )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
   pval = zeros(length(counters), 1);
   accumulated_outputs = sum(outputs, 2);
   for i = 1:length(counters)
       if isempty(find(accumulated_outputs, 1))
           continue
       end
       % Selected data samples
       Ds = zeros(counters(i), 1);
       Ds(1:accumulated_outputs(i)) = 1;
       
       % Other data samples
       other_idx = 1:length(counters);
       other_idx(i) = [];
       Do = zeros(sum(counters(other_idx)), 1);
       Do(1:sum(accumulated_outputs(other_idx))) = 1; 
       
       [~, pval(i)] = ttest2(Ds(:), Do(:));
   end
   if find(pval < alpha)
       [minval, prediction] = min(pval);
       if length(find(pval == minval)) > 1 % more than one class have the same p-val
           prediction = 0;
       end
   else
       prediction = 0;
   end
end
