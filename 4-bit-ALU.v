
//ALU control input	Operation
//  000	 Results = A & B (bitwise AND)
//  001	 Results = A | B (bitwise OR)
//  010 	 Results = A + B (aritmetic ADD)
//  110	 Results = A - B (arithmetic SUB)
//  111	 Result = 1, if A<B, else Result=0 (SLT)

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

module Overflow3(a,b,Over);
input a,b,Sum;
output Over;
wire nota , notb,and1,and2;

not(nota,a);
not(notb,b);
and(and1,a,notb);
and(and2,b,nota);
or(Over,and1,and2);

endmodule
//          a,  b,     Binvert,      Operation,         Cin, less,     Cout,   Result

module ALU0_2(a,b,Ainvert,Binvert,Operation,Cin,less,Cout,Result);
input a,b,Binvert,less,Ainvert;
input [1:0] Operation;
input Cin;
output Cout,Result,Sum;
wire b1,andout,orout,a1;

//xor (b1, b,Binvert);
xor(b1,b,Binvert);
and (andout,a1,b1 );
or(orout,a1,b1);
// or
//or(a1,a,Ainvert);
xor(a1,a,Ainvert);


fulladder fa(Sum,Cout,a1,b1,Cin);
mux4x1 m1(andout,orout,Sum,less,Operation[1],Operation[0],Result);

endmodule
//          a,b,Ainvert,Binvert,Operation,Cin,less,Set,Result,Overflow

module ALU3(a,b,Ainvert,Binvert,Operation,Cin,less,Sum,Result,Overflow);
input a,b,Binvert,less,Ainvert;
input [1:0] Operation;
input Cin;
output Sum,Result,Set,Overflow;
wire b1,andout,s1,notb,a1,Cout,t1;

xor(a1,a,Ainvert);
// or
or(orout,a1,b1);

xor(b1,b,Binvert);
//xor (a1,a,Ainvert);
// (b1, b,Binvert);
and(andout,a1,b1 );




fulladder fa(Sum,Cout,a1,b1,Cin);
mux4x1 m1(andout,orout,Sum,less,Operation[1],Operation[0],Result);

//nor(Overflow,Cout,Sum);
//Overflow3 ovr(Cin,Cout,Overflow);
xor(Overflow,Cout,Cin);

endmodule


module ALU(a,b,Operation,Zero,Overflow,Result);

input [3:0] a,b;
input [3:0] Operation;
wire [3:0] Carryout;
output [3:0]Result;
output Zero,Overflow;
wire Set;
//          a,   b,      Ainvert,     Binvert,      Operation,        Cin,  less,       Cout,   Result
ALU0_2 A1(a[0],b[0],Operation[3],Operation[2],Operation[1:0],Operation[2],  Set,Carryout[0],Result[0]),
       A2(a[1],b[1],Operation[3],Operation[2],Operation[1:0],  Carryout[0],1'b0,Carryout[1],Result[1]),
       A3(a[2],b[2],Operation[3],Operation[2],Operation[1:0],Carryout[1],  1'b0,Carryout[2],Result[2] );
       
//           a,   b,Ainvert,          Binvert,     Operation,          Cin,  less,     Set,    Result,Overflow
ALU3   A4(a[3],b[3],Operation[3],Operation[2],Operation[1:0],  Carryout[2],  1'b0,     Set, Result[3],Overflow);

nor(Zero,Result[0],Result[1],Result[2],Result[3]);

// Zero == xor of all result values
// full adder sum is equal to carryout
//1'b0 shows that the zero is one bit
//Overflow =xor of Carryin and Carryout
endmodule

module ins;

reg  signed[3:0] a,b;
reg  [3:0] Op;
wire signed [3:0]Result;

wire reg Zero,Overflow;

ALU alui(a,b,Op,Zero,Overflow,Result);

initial begin
    $display("   Op  a          b      Result   Zero    Overflow ");
    $monitor(" %b %b(%d) %b(%d)  %b(%d)   %b        %b", Op,a,a,b,b,Result,Result, Zero, Overflow);
           Op = 4'b0000; a = 4'b0111; b = 4'b0010;  // AND
        #1 Op = 4'b0001; a = 4'b0101; b = 4'b0010;  // OR
        #1 Op = 4'b0010; a = 4'b0101; b = 4'b0001;  // ADD
        #1 Op = 4'b0010; a = 4'b0111; b = 4'b0001;  // ADD with overflow (8+1=-8)
        #1 Op = 4'b0110; a = 4'b0101; b = 4'b0001;  // SUB
        #1 Op = 4'b0110; a = 4'b1111; b = 4'b0001;  // SUB
        #1 Op = 4'b0110; a = 4'b1111; b = 4'b1000;  // SUB with overflow (-1-(-8)=7)
        #1 Op = 4'b0111; a = 4'b0101; b = 4'b0001;  // SLT
        #1 Op = 4'b0111; a = 4'b0001; b = 4'b0011;  // SLT
        #1 Op = 4'b1100; a = 4'b0001; b = 4'b0011;  // Nor
        #1 Op = 4'b1101; a = 4'b0001; b = 4'b0011;  // Nand

end
endmodule
/* Test Results
op  a        b        result   zero overflow
000 0111( 7) 0010( 2) 0010( 2) 0    0
001 0101( 5) 0010( 2) 0111( 7) 0    0
010 0101( 5) 0001( 1) 0110( 6) 0    0
010 0111( 7) 0001( 1) 1000(-8) 0    1
110 0101( 5) 0001( 1) 0100( 4) 0    0
110 1111(-1) 0001( 1) 1110(-2) 0    0
110 1111(-1) 1000(-8) 0111( 7) 0    1
111 0101( 5) 0001( 1) 0000( 0) 1    0
111 0001( 1) 0011( 3) 0001( 1) 0    0
*/