
module crc24 (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        init,        // pulse high to load 0x555555
    input  logic        data_in,
    input  logic        data_valid,  // enable: only advance when data is valid
    output logic [23:0] crc_out
);

    logic [23:0] crc_reg;

    // CRC-24 polynomial: x^24 + x^10 + x^9 + x^6 + x^4 + x^3 + x + 1
    logic feedback = data_in ^ crc_reg[23];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            crc_reg <= 24'h555555;
        else if (init)
            crc_reg <= 24'h555555;
        else if (data_valid) begin
            crc_reg[23] <= crc_reg[22];
            crc_reg[22] <= crc_reg[21];
            crc_reg[21] <= crc_reg[20];
            crc_reg[20] <= crc_reg[19];
            crc_reg[19] <= crc_reg[18];
            crc_reg[18] <= crc_reg[17];
            crc_reg[17] <= crc_reg[16];
            crc_reg[16] <= crc_reg[15];
            crc_reg[15] <= crc_reg[14];
            crc_reg[14] <= crc_reg[13];
            crc_reg[13] <= crc_reg[12];
            crc_reg[12] <= crc_reg[11];
            crc_reg[11] <= crc_reg[10];
            crc_reg[10] <= crc_reg[9] ^ feedback;
            crc_reg[9]  <= crc_reg[8] ^ feedback;
            crc_reg[8]  <= crc_reg[7];
            crc_reg[7]  <= crc_reg[6];
            crc_reg[6]  <= crc_reg[5] ^ feedback;
            crc_reg[5]  <= crc_reg[4];
            crc_reg[4]  <= crc_reg[3] ^ feedback;
            crc_reg[3]  <= crc_reg[2] ^ feedback;
            crc_reg[2]  <= crc_reg[1];
            crc_reg[1]  <= crc_reg[0] ^ feedback;
            crc_reg[0]  <= feedback;
        end
    end

    assign crc_out = crc_reg;

endmodule
