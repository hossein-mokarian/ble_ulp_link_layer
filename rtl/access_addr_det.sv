
module access_addr_det (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        rx_bit,
    input  logic        rx_valid,       // enable
    input  logic [31:0] expected_aa,    // 0x8E89BED6 for advertising
    
    output logic        aa_match
);

    logic [31:0] shift_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 32'h0;
            aa_match  <= 1'b0;
        end else if (rx_valid) begin
            shift_reg <= {shift_reg[30:0], rx_bit};
            aa_match  <= ({shift_reg[30:0], rx_bit} == expected_aa);
        end
        // when rx_valid=0, nothing toggles → gatable
    end

endmodule
