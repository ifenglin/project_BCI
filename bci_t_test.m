function [ prediction ] = bci_t_test( Data, alpha )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
   stop = false;
   pval = zeros(size(Data, 1), 1);
   for i = 1:size(Data, 1)
       other_idx = 1:size(Data, 1);
       other_idx(1) = [];
       Ds = Data(i,:); % Selected class 
       Do = Data(other_idx, :); % Other classes
       [~, pval(i)] = ttest2(Ds(:), Do(:));
       if pval(i) < alpha
           stop = true;
       end
   end
   if stop
       [minval, prediction] = min(pval);
       if length(find(pval == minval)) > 1 % more than one class have the same p-val
           prediction = 0;
       end
   else
       prediction = 0;
   end
end
