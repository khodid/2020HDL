module ENCRIP (nRST, CLK, Din, ECRo);
    input [2:0] Din;
    input CLK, nRST;
    output reg [4:0] ECRo; // 배열 중 제일 큰 수가 20임. -> 5bit

    // 숫자배열 : 7 1 9 6 _ 10 11 20 8
    always @ ( negedge nRST, posedge CLK ) begin
        if(!nRST) ECRo = 5'b00000;
        else begin
            case (Din)
                3'b000: ECRo = 7;
                3'b001: ECRo = 1;
                3'b010: ECRo = 9;
                3'b011: ECRo = 6;
                3'b100: ECRo = 10;
                3'b101: ECRo = 11;
                3'b110: ECRo = 20;
                default: ECRo = 8; // 3'b111
            endcase
        end
    end

endmodule //
