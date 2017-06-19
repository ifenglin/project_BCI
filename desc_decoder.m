function [ hits ] = desc_decoder( descs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
hits = zeros(10, 1);
for i = 1:size(descs, 1)
    desc = descs(i)-60;
    if desc>=1 && desc <=5
       hits(1) = hits(1)+1;
    end
    if desc>=6 && desc <=10
       hits(2) = hits(2)+1;
    end
    if desc>=11 && desc <=15
       hits(3) = hits(3)+1;
    end
    if (desc>=16 && desc <=19) || desc == 1
       hits(4) = hits(4)+1;
    end
    if (desc>=20 && desc <=22) || desc == 2 || desc == 6
       hits(5) = hits(5)+1;
    end
    if (desc>=23 && desc <=24) || desc == 3 || desc == 7 || desc == 11
       hits(6) = hits(6)+1;
    end
    if desc == 4 || desc == 8 || desc == 12 || desc == 16 || desc == 25
       hits(7) = hits(7)+1;
    end
    if desc == 5 || desc == 9 || desc == 13 || desc == 17 || desc == 20
       hits(8) = hits(8)+1;
    end
    if desc == 10 || desc == 14 || desc == 18 || desc == 21 || desc == 23
       hits(9) = hits(9)+1;
    end
    if desc == 15 || desc == 19 || desc == 22 || desc == 24 || desc == 25
       hits(10) = hits(10)+1;
    end
end

