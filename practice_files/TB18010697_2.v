module TB_2 ();
// input signal
    reg [31:0] A, B;
    reg [2:0] CTRL;
    reg [4:0] NUM;
// output signal
    wire [31:0] Y;
// signal initializing
    initial begin
        A = 30;
        B = 90;
        NUM = 5;
    end
    initial begin
            CTRL = 3'b000;
    #10     CTRL = 3'b001;
    #10     CTRL = 3'b010;
    #10     CTRL = 3'b011;
    #10     CTRL = 3'b100;
    #10     CTRL = 3'b101;
    #10     CTRL = 3'b110;
    #10     CTRL = 3'b111;
    #10     CTRL = 3'b000;
    end
// instance
    ALU U0(CTRL, NUM, A, B, Y);
endmodule // TB_2
