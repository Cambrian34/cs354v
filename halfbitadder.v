module halfadder(x,y,S,C);
//S = sum
//C = carry

input x,y;
output S,C;

xor x1 (S,x,y);
and a1 (C,x,y);

endmodule

module test1;

reg signed x,y;
wire S,C;

halfadder m1(x,y,S,C);
initial begin
    $display("a b S C");
    $monitor("%b %b %b %b ", x,y,S,C);
    x = 0;y = 0;
    #1
    x = 0;y = 1 ;
    #1
    x = 1;y = 0 ;
    #1
    x = 1;y = 1;
end
endmodule