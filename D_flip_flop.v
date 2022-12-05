module Dflipflops(D,Clk,Q,NQ);
input D,Clk;
output Q,NQ;
wire w1,w2,w3;

not (w1,D);
nand (w2,D,Clk);
nand (w3,w1,Clk);
nand (NQ,Q,w3);
nand (Q,NQ,w2);

endmodule