module halfadder(S,C,x,y);
//S = sum
//C = carry

input x,y;
output S,C;

xor x1 (S,x,y);
and a1 (C,x,y);

endmodule

module increm(S,A,i);

input [1:0] A;
input i;
output [1:0]S;
output C;
wire c1,c2;

halfadder HA1(S[0],c1,A[0],i),
            HA2(S[1],c2,c1,A[1]);
endmodule

module twocomp(S,A,i);
input [1:0]A;
input i;
output [1:0]S;
output C1;
wire  [1:0]notA;

not n1(notA[0],A[0]);
not n2(notA[1],A[1]);

increm i1(S,notA,i);

endmodule

module ins;
reg signed [1:0]A;
reg signed i;

wire [1:0]S;

twocomp t1(S,A,i);
initial begin
    $display("A S ");
    $monitor("%b %b ", A,S );
   
    A[2]=0; A[1]=0; A[0]=0;i=1;
    #1 // delays with 1 time unit
    A[2]=0; A[1]=0; A[0]=1;i=1;
    #1 // delays with 1 time unit
    A[2]=0; A[1]=1; A[0]=0;i=1;
    #1 // delays with 1 time unit
    A[2]=0; A[1]=1; A[0]=1;i=1;
    #1 // delays with 1 time unit
    A[2]=1; A[1]=0; A[0]=0;i=1;
    #1 // delays with 1 time unit
    A[2]=1; A[1]=0; A[0]=1;i=1;
    #1 // delays with 1 time unit
    A[2]=1; A[1]=1; A[0]=0;i=1;
    #1 // delays with 1 time unit
    A[2]=1; A[1]=1; A[0]=1;i=1;
   
end
endmodule