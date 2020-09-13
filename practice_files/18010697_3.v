module PATTERN_DET (nRST, CLK, Din, DETo);
    input nRST, CLK, Din;
    output DETo;
/*
이진수 패턴:
자신의 학번을 각 자릿수마다 짝수면 1, 홀수면 0으로 하여 2진수 형태로 만든다
18010697 -> 01101100
3bit 필요할 듯..

Reference : 11주차 심화 문제 답안
*/

    reg [4:0] state_reg, next_state;

    parameter 	start 	= 4'b0000,
                ST1		= 4'b0001,
                ST2		= 4'b0010,
                ST3		= 4'b0011,
                ST4     = 4'b0100,
                ST5     = 4'b0101,
                ST6     = 4'b0110,
                ST7     = 4'b0111,
                ST8     = 4'b1000;

    assign DETo = (state_reg == ST7 && Din == 0) ? 1:0;

    always @(posedge CLK, negedge nRST) begin
        if(!nRST) begin
            state_reg <= start;
        end
        else begin
            state_reg <= next_state;
        end
    end
    // 01101100


    always @( * ) begin
        case(state_reg)
            start:
                if(Din==0)			next_state <= ST1;
                else if(Din==1)		next_state <= start;
                else				next_state <= start;
            ST1: // 0
                if(Din==0)			next_state <= ST1;//00
                else if(Din == 1)	next_state <= ST2;//01
                else				next_state <= start;
            ST2: // 01
                if(Din==0)			next_state <= ST1; //010
                else if(Din == 1)	next_state <= ST3; //011
                else 				next_state <= start;
            ST3: // 011
                if(Din==0)			next_state <= ST4; // 0110
                else if(Din==1)		next_state <= start;//0111
                else					next_state <= start;
            ST4: // 0110
                if(Din==0)			next_state <= ST1; // 01100
                else if(Din==1)		next_state <= ST5; // 01101
                else					next_state <= start;
            ST5: // 01101
                if(Din==0)			next_state <= ST1; // 011010
                else if(Din==1)		next_state <= ST6; // 011011
                else					next_state <= start;
            ST6: // 011011
                if(Din==0)			next_state <= ST7; // 0110110
                else if(Din==1)		next_state <= start; //0110111
                else					next_state <= start;
            ST7: // 0110110
                if(Din==0)			next_state <= ST8; // 01101100
                else if(Din==1)		next_state <= ST5; // 01101101
                else					next_state <= start;
            ST8: // 01101100
                if(Din==0)			next_state <= ST1; // 011011000
                else if(Din==1)		next_state <= ST2; // 011011001
                else				next_state <= start;
        endcase
    end
endmodule //
