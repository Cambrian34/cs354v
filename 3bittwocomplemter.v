module halfadder(S,C,x,y);
//S = sum
//C = carry

input x,y;
output S,C;

xor x1 (S,x,y);
and a1 (C,x,y);

endmodule

module increm(S,C,A,i);

input [2:0] A;
input i;
output [2:0]S;
output C;
wire c1,c2;

halfadder HA1(S[0],c1,A[0],i),
            HA2(S[1],c2,c1,A[1]),
            HA3(S[2],C,c2,A[2]);


endmodule

module twocomp(S,A,i);
input [2:0]A;
input i;
output [2:0]S;
output C1;
wire  [2:0]notA;

not n1(notA[0],A[0]);
not n2(notA[1],A[1]);
not n3(notA[2],A[2]);

increm i1(S,C1,notA,i);

endmodule

module ins;
reg signed [2:0]A;
reg signed i;

wire [2:0]S;

twocomp t1(S,A,i);
initial begin
    //$display("a b S C");
    $monitor("%b %b %d", A,S ,S);
   
    A[0]=0; A[1]=0; A[2]=0;i=1;
    #1 // delays with 1 time unit
    A[0]=0; A[1]=0; A[2]=1;i=1;
    #1 // delays with 1 time unit
    A[0]=0; A[1]=1; A[2]=0;i=1;
    #1 // delays with 1 time unit
    A[0]=0; A[1]=1; A[2]=1;i=1;
    #1 // delays with 1 time unit
    A[0]=1; A[1]=0; A[2]=0;i=1;
    #1 // delays with 1 time unit
    A[0]=1; A[1]=0; A[2]=1;i=1;
    #1 // delays with 1 time unit
    A[0]=1; A[1]=1; A[2]=0;i=1;
    #1 // delays with 1 time unit
    A[0]=1; A[1]=1; A[2]=1;i=1;
   
end
endmodule