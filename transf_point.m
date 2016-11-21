function [u v] = transf_point(H, x, y) 

s0 = [x; y; 1];

s = H*s0;

s(1) = s(1)/s(3);
s(2) = s(2)/s(3);
s(3) = s(3)/s(3);

s(1) = s(1) -720;
s(2) = s(2) - 320;

u = s(1);
v = s(2);

