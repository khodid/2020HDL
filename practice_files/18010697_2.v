module ALU (CTRL, NUM, A, B, Y);
    input [31:0] A, B;
    input [2:0] CTRL;
    input unsigned [4:0] NUM;
    output reg [31:0] Y;
/*

내 배열:  7 1 9 6 0 1 0 8
CTRL   : 0 1 2 3 4 5 6 7
0 A + B
5 A를 NUM비트 만큼 arith. shift right
1 A - B
6 A × B
2 A를 NUM비트 만큼 logical shift left
7 A를 1만큼 증가
3 A를 NUM비트 만큼 arith. shift left
8 A를 1만큼 감소
4 A를 NUM비트 만큼 logical shift right
9 A and B (bitwise operation)
    */
    always @ ( * ) begin
        case (CTRL)
            3'b000: Y = A + 1; // 7
            3'b001: Y = A - B;// 1
            3'b010: Y = A & B; // 9
            3'b011: Y = A * B;// 6
            3'b100: Y = A + B;// 0
            3'b101: Y = A - B;// 1
            3'b110: Y = A + B;// 0
            default: Y = A - 1; // 3'b111, 8
        endcase
    end
endmodule //
