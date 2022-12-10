/*
Name:Alistair Chambers
Project 3
*/

module cpu (Instruction, WriteData, CLK);
   input [8:0] Instruction;
   input CLK;
   output [3:0] WriteData;
   wire [8:0] IR;
   wire [3:0] A,B,Result;
   wire [2:0] ALUctl;
   //done.
   instr_reg instr(Instruction,IR,CLK);
   //done.
   control ctl (IR[8:6],Sel,ALUctl);
   //done.
   quad2x1mux mux(IR[5:2],Result,Sel,WriteData);
   //
   regfile regs(IR[5:4],IR[3:2],IR[1:0],WriteData,A,B,CLK);
   //done? used behavioural version due to overflow error in my ALU codebase.
   ALU alu (ALUctl, A, B, Result);
endmodule

//complete
module instr_reg (Instruction,IR,Clk);
   input [8:0] Instruction;
   input Clk;
   output [8:0] IR;
D_flip_flop d1(Instruction[0],Clk,IR[0]),
            d2(Instruction[1],Clk,IR[1]),
            d3(Instruction[2],Clk,IR[2]),
            d4(Instruction[3],Clk,IR[3]),
            d5(Instruction[4],Clk,IR[4]),
            d6(Instruction[5],Clk,IR[5]),
            d7(Instruction[6],Clk,IR[6]),
            d8(Instruction[7],Clk,IR[7]),
            d9(Instruction[8],Clk,IR[8]);
    
endmodule

module D_flip_flop(D,CLK,Q);
   input D,CLK; 
   output Q; 
   wire CLK1, Y;
   not  not1 (CLK1,CLK);
   D_latch D1(D,CLK, Y),
           D2(Y,CLK1,Q);
endmodule 


module D_latch(D,C,Q);
   input D,C; 
   output Q;
   wire x,y,D1,Q1; 
   not  not1  (D1,D);
   nand nand1 (x,D, C), 
        nand2 (y,D1,C), 
        nand3 (Q,x,Q1),
        nand4 (Q1,y,Q); 
  
endmodule 
//de-concats  4 bits into 1 and 3 bits 
module dissever(a,Sum1,Sum2);
input [3:0] a;
output [2:0]Sum2;
output Sum1;
wire  a0,a1,a2,a3;
//Sum1 = a[0];
not (a0, a[0]),
(a1, a[1]),
(a2, a[2]),
(a3, a[3]);

not (Sum1,a3),
(Sum2[0],a0),
(Sum2[1],a1),
(Sum2[2],a2);


endmodule

module ifis(a,b);
input [2:0]a;
output[3:0]b;
wire [5:0]w;
wire [2:0] no;

//a[2]=x
//a[0]=z
not(no[0],a[0]);//z
not(no[1],a[1]);//y
not(no[2],a[2]);//x


or(b[3],no[2],no[0]);

and(w[0],no[2],no[1],a[0]);
and(w[1],a[2],no[1],no[0]);
or(b[2],w[0],w[1]);

and(w[2],no[2],no[1]);
and(w[3],no[1],no[0]);
or(b[1],w[2],w[3]);

and(w[4],no[2],a[0],a[1]);
and(w[5],a[2],no[1],no[0]);
or(b[0],w[4],w[5]);

endmodule
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
//done
//              IR[8:6],Sel,ALUctl
module control (OP,Sel,ALUctl);
  input [2:0] OP;
  //3 bit input
  wire [3:0] Selal;
  //Replace the following with gate-level code
  output  Sel;
  output   [2:0] ALUctl;
/*
  always @(OP) case (OP)
  //{} concat it to 4 bits 
    3'b000: {Sel,ALUctl} = 4'b1010; // ADD
    3'b001: {Sel,ALUctl} = 4'b1110; // SUB
    3'b010: {Sel,ALUctl} = 4'b1000; // AND
    3'b011: {Sel,ALUctl} = 4'b1001; // OR
    3'b100: {Sel,ALUctl} = 4'b1111; // SLT
    3'b101: {Sel,ALUctl} = 4'b0000; // LI
  endcase
 */
ifis t1(OP,Selal);
dissever d1(Selal,Sel,ALUctl);

endmodule
//done
module ALU (ALUctl, A, B, ALUOut);
  input [2:0] ALUctl;
  input [3:0] A,B;
  output reg [3:0] ALUOut;
  output Zero,Overflow;
  always @(ALUctl, A, B) //re-evaluate if these change
  case (ALUctl)
    3'b000: ALUOut <= A & B;
    3'b001: ALUOut <= A | B;
    3'b010: ALUOut <= A + B;
    3'b110: ALUOut <= A - B;
    3'b111: ALUOut <= A < B ? 1:0;
   endcase
endmodule
             //      2         2        2                    4          4   1
//to do last.    IR[5:4],  IR[3:2], IR[1:0],WriteData,       A,         B,CLK
module regfile (ReadReg1,ReadReg2,WriteReg,WriteData,ReadData1,ReadData2,CLK);
  input [1:0] ReadReg1,ReadReg2,WriteReg; //2bits
  input [3:0] WriteData;
  input CLK;
  output [3:0] ReadData1,ReadData2;
  reg [3:0]Regs[0:3]; //4 registers with 4 bits each
  //R1,R2
  wire [0:3] D,b;


assign ReadData1 = Regs[ReadReg1];
assign ReadData2 = Regs[ReadReg2];
initial Regs[0] = 0;
always @(negedge CLK)
Regs[WriteReg] = WriteData;

/*
decoder dc(D,in[0],in[1],Clk);
//Re
Register R1(ReadReg1,Clk,ReadData1),
           R2(ReadReg2,Clk,ReadData2),
          R2(WriteReg,Clk,WriteData);
mux4x1 m1(),
         m2();
*/

endmodule

module Register(in,Clk,b);
input [3:0]in;
output [3:0]b;
input Clk;
wire [3:0]a;
//decoder dc(a,in[0],in[1],1'b1);
D_flip_flop d1(in[0],Clk,b[0]),
            d2(in[1],Clk,b[1]),
            d3(in[2],Clk,b[2]),
            d4(in[3],Clk,b[3]);
       

endmodule

//done
module quad2x1mux (I0,I1,Sel,Out);
  input [3:0] I0,I1;
  input Sel;
  output [3:0] Out;
// Replace the following with gate-level code
 //assign Out = (Sel)? I1: I0;
mult m1(I0[0],I1[0],Sel,Out[0]),
     m2(I0[1],I1[1],Sel,Out[1]),
     m3(I0[2],I1[2],Sel,Out[2]),
     m4(I0[3],I1[3],Sel,Out[3]);

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

//2 to 4 decoder
module decoder( D, A, B, enable );
     output [0:3] D;            // vector of 4 bits
     input  A, B;
     input  enable;
     wire   Anot, Bnot, enableNot;
     not
       G1 (Anot, A),            // note syntax:  list of gates
       G2 (Bnot, B),            // separated by ,
       G3 (enableNot, enable);
     nand
       G4 (D[0], Anot, Bnot, enableNot ),
       G5 (D[1], Anot, B,    enableNot ),
       G6 (D[2], A,    Bnot, enableNot ),
       G7 (D[3], A,    B,    enableNot );
endmodule

module ins;
reg [8:0] Instruction;
   reg CLK;
   wire [3:0] WriteData;
   cpu cpu1 (Instruction, WriteData, CLK);
   initial
   begin
     $display("\nCLK Instruction WriteData\n-------------------------"); 
     $monitor("%b   %b   %d (%b)", CLK,Instruction,WriteData,WriteData);
#1 Instruction = 9'b101_0111_01; // li $1, 7 # $1 = 7
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
     #1 Instruction = 9'b101_0101_10; // li $2, 5 # $2 = 5 
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
     #1 Instruction = 9'b001_01_10_11; // sub $3, $1, $2 # $3 = 2
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
//   Add more instructions
     #1 Instruction = 9'b101_1010_11; //li
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
      #1 Instruction = 9'b011_10_11_10;// or
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
      #1 Instruction = 9'b010_10_11_11; //and
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
      #1 Instruction = 9'b100_11_10_10; //slt
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
      #1 Instruction = 9'b000_11_10_10;//add
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
      #1 Instruction = 9'b000_01_10_11;//add
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction
      #1 Instruction = 9'b100_10_11_01; //slt
        CLK=1;
     #1 CLK=0; // Negative edge - execute instruction

//   ...
   end
    endmodule
/*
x   xxxxxxxxx    x (xxxx)
1   101011101    x (xxxx)
0   101011101    7 (0111)
1   101010110    7 (0111)
0   101010110    5 (0101)
1   001011011    5 (0101)
0   001011011    2 (0010)


li $t1, 7                 # $t1 = 7
li $t2, 5                 # $t2 = 5 (4'b0101)
sub $t3, $t1, $t2   # $t3 = 2 (7-5=2)
li $t3, 10               # $t3 = 10 (4'b1010)
or $t2, $t2, $t3      # $t2 = 15 (4'b1111)
and $t3, $t2, $t3   # $t3 = 10 (4'b1010)
slt $t2, $t3, $t2      # $t2 = 1
add $t2, $t3, $t2    # $t2 = 11 (4'b1011=-5)
add $t3, $t1, $t2   # $t3 = 2 (7+(-5)=2)
slt $t1, $t2, $t3      # $t1 = 0 (behavioral ALU) or 1 (gate-level ALU)
*/