module PULSE_GEN (nRST, CLK, PULSEo);
    input nRST, CLK;
    output reg PULSEo;

    // 배열: 7 1 9 6 10 11 20 8
    reg [4:0] cnt; // 20까지 있음.
    reg [4:0] target;
    reg [2:0] target_count;

    always @ ( negedge nRST, posedge CLK ) begin
        if(!nRST) begin
            cnt <= 1;
            PULSEo <= 0;
            target_count <= 0;
            target <= 7;
        end
        else begin
            if (cnt == target-1)begin
                cnt <= cnt +1;
                PULSEo <= 1;
                target_count <= (target_count != 7)? (target_count+1):(0);
            end
            else if(cnt == target) begin
                cnt <= 1;
                PULSEo <= 0;
                case (target_count)
                    3'b001: target <= 1;
                    3'b010: target <= 9;
                    3'b011: target <= 6;
                    3'b100: target <= 10;
                    3'b101: target <= 11;
                    3'b110: target <= 20;
                    3'b111: target <= 8;
                    default: target <= 7;
                endcase // * repeat

            end
            else cnt <= cnt + 1;
        end
    end
endmodule // module PULSE_GEN (nRST, CLK, PULSEo);
