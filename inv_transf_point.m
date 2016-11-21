function [u v] = inv_transf_point(H, x, y) 



s0 = [x+720; y+320; 1];

s = H\s0;

s(1) = s(1)/s(3);
s(2) = s(2)/s(3);
s(3) = s(3)/s(3);

u = s(1);
v = s(2);

