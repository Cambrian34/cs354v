module halfadder(S,C,x,y);
//S = sum
//C = carry

input x,y;
output S,C;

xor x1 (S,x,y);
and a1 (C,x,y);

endmodule

module fulladder (S,C,x,y,z);
input x,y,z;
output S,C;
wire S1,C1,C2;

halfadder HA1 (S1,C1,x,y),
          HA2 (S,C2,S1,z);
    or C3(C,C2,C1);    
endmodule 

module mult(x,y,z,S);
input x,y,z;
output S;
wire c0,c1,c2;
not n1(c0,z);
and n2(c1,x,c0);
and n3(c2,y,z);
or  n4(S,c1,c2);

endmodule
//            andout,orout,Sum,less,Operation[0],Operation[2],Result
module mux4x1(     a,    b,  c,   d,          s0,         s1, ans);

     
output ans;
input a, b, c, d, s0, s1;
wire s0bar, s1bar, T1, T2, T3, T4;

not (s0bar, s0);
not (s1bar, s1);
and (T1, a, s0bar, s1bar);
and (T2, b, s0bar, s1);
and (T3, c, s0, s1bar);
and (T4, d, s0, s1);
or(ans, T1, T2, T3, T4);


endmodule
//          a,  b,     Binvert,      Operation,         Cin, less,     Cout,   Result

module ALU0_2(a,b,Ainvert,Binvert,Operation,Cin,less,Cout,Result);
input a,b,Binvert,less,Ainvert;
input [1:0] Operation;
input Cin;
output Cout,Result,Sum;
wire b1,andout,orout,a1;

xor (b1, b,Binvert);
and (andout,a1,b1 );
or(orout,a1,b1);
// or
xor(a1,a,Ainvert);

fulladder fa(Sum,Cout,a1,b1,Cin);
mux4x1 m1(andout,orout,Sum,less,Operation[0],Operation[1],Result);

endmodule

module ins;

reg signed a,b,Binvert,less,Ainvert,Cin;
reg [1:0] Operation;
wire signed Cout,Result,Sum;
wire b1,andout,orout,a1;

ALU0_2 a21(a,b,Ainvert,Binvert,Operation,Cin , less,Cout,Result);

initial begin
    $monitor("%b %b %b", a,b,Result);
    a = 1'b0; b=1'b0; Ainvert = 1'b0; Binvert =1'b0; Operation = 2'b00; Cin = 1'b0;less =1'b0;  
end
endmodule