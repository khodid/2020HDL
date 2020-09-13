module TB_1 ();
    // input signal
    reg clk, nRST;
    reg [2:0] Din;

    // output signal
    wire [4:0] ECRo;
    // signal initializing
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    initial begin
        nRST = 1'b1;
        Din = 3'b000;
        #5 nRST = 1'b0;
        #5 nRST = 1'b1;
        #10 Din = 3'b001;
        #10 Din = 3'b010;
        #10 Din = 3'b011;
        #10 Din = 3'b100;
        #10 Din = 3'b101;
        #10 Din = 3'b110;
        #10 Din = 3'b111;
        #10 Din = 3'b000;
    end
    // instance
    ENCRIP U0(nRST, clk, Din, ECRo);
endmodule // TB_1
