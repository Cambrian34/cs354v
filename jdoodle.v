module Xerr(x,y,S,C);
//S = sum
//C = carry

input x,y;
output S, C;

xor x1 (s,y,x);
and a1 (C, x,y);

endmodule