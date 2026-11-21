
module whitening (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       init,
    input  logic [6:0] channel_seed,  // channel_num + 1
    input  logic       data_in,
    input  logic       data_valid,
    output logic       data_out
);

    logic [6:0] lfsr;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 7'h01;  // placeholder, real seed loaded on init
        else if (init)
            lfsr <= channel_seed;
        else if (data_valid) begin
            lfsr[0] <= lfsr[6];
            lfsr[1] <= lfsr[0];
            lfsr[2] <= lfsr[1];
            lfsr[3] <= lfsr[2] ^ lfsr[6];
            lfsr[4] <= lfsr[3] ^ lfsr[6];
            lfsr[5] <= lfsr[4];
            lfsr[6] <= lfsr[5];
        end
    end

    assign data_out = data_in ^ lfsr[6];

endmodule
