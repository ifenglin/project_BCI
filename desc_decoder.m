function [ accumulated_outputs, outputs ] = desc_decoder( descs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
outputs = zeros(10, size(descs, 1));
for i = 1:size(descs, 1)
    desc = descs(i)-60;
    if desc>=1 && desc <=5
       outputs(1, i) = 1;
    end
    if desc>=6 && desc <=10
       outputs(2, i) = 1;
    end
    if desc>=11 && desc <=15
       outputs(3, i) = 1;
    end
    if (desc>=16 && desc <=19) || desc == 1
       outputs(4, i) = 1;
    end
    if (desc>=20 && desc <=22) || desc == 2 || desc == 6
       outputs(5, i) = 1;
    end
    if (desc>=23 && desc <=24) || desc == 3 || desc == 7 || desc == 11
       outputs(6, i) = 1;
    end
    if desc == 4 || desc == 8 || desc == 12 || desc == 16 || desc == 25
       outputs(7, i) = 1;
    end
    if desc == 5 || desc == 9 || desc == 13 || desc == 17 || desc == 20
       outputs(8, i) = 1;
    end
    if desc == 10 || desc == 14 || desc == 18 || desc == 21 || desc == 23
       outputs(9, i) = 1;
    end
    if desc == 15 || desc == 19 || desc == 22 || desc == 24 || desc == 25
       outputs(10, i) = 1;
    end
end
accumulated_outputs = sum(outputs,2);

