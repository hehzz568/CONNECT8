// block_generator.v — generate 3
module block_generator(
    input  wire clk, input wire reset, input wire generate_new,
    output reg [63:0] block1, output reg [63:0] block2, output reg [63:0] block3
);
    reg [15:0] lfsr;
    always @(posedge clk or posedge reset)
        if (reset) lfsr <= 16'hACE1;
        else       lfsr <= {lfsr[14:0], lfsr[15]^lfsr[13]^lfsr[12]^lfsr[10]};

    // 5 basics 
    function [63:0] shape;
        input [2:0] sel;
        reg [15:0] m;
        begin
            case(sel)
              0: m = 16'b0000_1111_0000_0000;            // 4
              1: m = 16'b0000_1100_1100_0000;            // 2x2
              2: m = 16'b0001_0001_0001_0001;            // 4
              3: m = 16'b0000_1110_0100_0000;            // L
              default: m =16'b0000_1110_0010_0000;       // T
            endcase
            shape = {48'b0, m};
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            block1 <= shape(0); block2 <= shape(1); block3 <= shape(2);
        end else if (generate_new) begin
            block1 <= shape(lfsr[2:0]);
            block2 <= shape(lfsr[5:3]);
            block3 <= shape(lfsr[8:6]);
        end
    end
endmodule

