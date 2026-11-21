
module ble_soc_top (
    input logic clk_aon,
    input logic rst_n,

    input logic clk_core,
    input logic rst_n_core
);

    logic wake_reg;
    logic core_pwr_en;


    aon_ctrl u_aon_ctrl (
        .clk_aon(clk_aon),
        .rst_n(rst_n),
        .wake_reg(wake_reg),
        .core_pwr_en(core_pwr_en)
    );

    ble_baseband u_ble_basedband (
        .clk_core(clk_core),
        .rst_n_core(rst_n_core)
    );

endmodule