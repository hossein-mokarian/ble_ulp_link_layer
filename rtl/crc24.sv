
module crc24 (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        init,        // pulse high to load 0x555555
    input  logic        data_in,
    input  logic        data_valid,  // enable: only advance when data is valid
    
    output logic [23:0] crc_out
);

    localparam CRC_SEED = 24'h515555;

    logic [23:0] crc_reg;

    // CRC-24 polynomial: x^24 + x^10 + x^9 + x^6 + x^4 + x^3 + x + 1
    logic feedback;
    
    assign feedback = data_in ^ crc_reg[23];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            crc_reg <= CRC_SEED;
        else if (init)
            crc_reg <= CRC_SEED;
        else if (data_valid) begin
            crc_reg <= {crc_reg[22:0], 1'b0} ^ (feedback ? 24'h00065B : 24'b0);
        end
    end

    assign crc_out = crc_reg;

endmodule
