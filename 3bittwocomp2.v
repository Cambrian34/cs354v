module twocomp(S,A,i);
input [2:0]A;
input i;
output [2:0]S;
output C1;
wire  [2:0]notA;
wire [5:0]a;

not  n1(notA[0],A[0]);
not  n2(notA[1],A[1]);
not  n3(notA[2],A[2]);

and  a1(a[0],notA[2],A[0]);
and  a2(a[1],notA[2],A[1]);
and  a3(a[2],A[2],notA[1],notA[0]);
and  a4(a[3],notA[1],A[0]);
and  a5(a[4],A[1],notA[0]);

or o1(S[2],a[0],a[1],a[2]);
or o2(S[1],a[3],a[4]);
not n4(S[0],A[0]);

endmodule

module ins;
reg signed [2:0]A;
reg i;
wire [2:0]S;

twocomp t1(S,A,i);
initial begin
    //$display("A      S  ");
    $monitor("%b %b    %d", A,S ,S);
   
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