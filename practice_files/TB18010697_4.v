module TB_4 ();
    // input signal
    reg CLK, nRST;

    // output signal
    wire PULSEo;

    // signal initializing
    initial begin
        CLK = 1'b0; nRST = 1;
        forever #5 CLK = ~CLK;
    end

    initial begin
        #5 nRST = 0;
        #5 nRST = 1;
    end
    // instance
    PULSE_GEN U0(nRST, CLK, PULSEo);
endmodule // TB_4
