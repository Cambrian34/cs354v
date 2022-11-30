module mult(x,y,z,S);
input x,y,z;
output S;
wire c0,c1,c2;
not n1(c0,z);
and n2(c1,x,c0);
and n3(c2,y,z);
or  n4(S,c1,c2);

endmodule

module test1;
reg a,b,c;

mult m1(a,b,c,s);
initial begin
    $display("a b c s");
    $monitor("%b %b %b %b", a,b,c,s);
    a=0; b=0; c=0;
    #1 // delays with 1 time unit
    a=0; b=0; c=1;
    #1 // delays with 1 time unit
    a=0; b=1; c=0;
    #1 // delays with 1 time unit
    a=0; b=1; c=1;
    #1 // delays with 1 time unit
    a=1; b=0; c=0;
    #1 // delays with 1 time unit
    a=1; b=0; c=1;
    #1 // delays with 1 time unit
    a=1; b=1; c=0;
    #1 // delays with 1 time unit
    a=1; b=1; c=1;
end
endmodule