
module aon_ctrl (
    input logic clk_aon,
    input logic rst_n,
    input logic wake_reg,
    output logic core_pwr_en
);

    always_ff @(posedge clk_aon or negedge rst_n) begin
        if (!rst_n) begin
            core_pwr_en <= 1'b0;
        end else begin
            core_pwr_en <= wake_reg;
        end 
    end

endmodule
