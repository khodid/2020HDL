module TB_3 ();
    // input signal
    reg CLK, nRST, Din;
    wire DETo;
    // output signal

    // signal initializing
    initial begin
        CLK = 1'b1;
        forever #5 CLK = ~CLK;
    end
    initial begin
        nRST = 1; Din = 1;
        #10 nRST = 0;
        #10 nRST = 1;
        #10 Din = 0;
        #10 Din = 0;
        #10 Din = 1; //
        #10 Din = 0;
        #10 Din = 1;
        #10 Din = 1;
        #10 Din = 0;
        #10 Din = 1;
        #10 Din = 1;
        #10 Din = 0;
        #10 Din = 0;
        #10 Din = 1;
        #10 Din = 0;
        #10 Din = 1;
        #10 Din = 0;
        #10 Din = 1;
        #10 Din = 0;

    end

    // instance
    PATTERN_DET U0(nRST, CLK, Din, DETo);

endmodule // TB_3
