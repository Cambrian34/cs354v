module halfadder(S,C,x,y);
//S = sum
//C = carry

input x,y;
output S,C;

xor x1 (S,x,y);
and a1 (C,x,y);

endmodule

module fulladder(S,C,x,y,z);

input x,y,z;
output S,C;
wire S1,C1,C2;

halfadder HA1(S1,C1,x,y),
          HA2(S,C2,S1,z);
    or C3(C,C2,C1);    

endmodule

module yzxor(S,x,y);
input x,y;
output S;

xor n1(S,x,y);

endmodule
module onebittwocomp(A,B,C,C1,x,y,z);
input x;
input  y,z;
output A,B,C;
output C2;
wire c0,c1;
wire  n;

yzxor n2(n,y,z);


halfadder HA1,
HA2,;

            
endmodule

module ins;

reg signed x,y;
reg  z;

wire S1,S2,S3,C1;

onebittwocomp t1(S1,S2,S3,C1,x,y,z);
initial begin
    //$display("a b S C");
    $monitor("%b %b %b  %b %b %b ", x,y,z ,S1,S2,S3 );
    x=0; y=1; z=0;
    //#1 // delays with 1 time unit
   
end
endmodule