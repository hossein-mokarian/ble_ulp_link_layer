
module ble_soc_top (
    input logic clk_aon,
    input logic rst_n,

    input logic clk_core,
    input logic rst_n_core
);

    logic wake_req;
    logic core_pwr_en;


    // PD_AON domain: always powered
    aon_ctrl u_aon_ctrl (
        .clk_aon     (clk_aon),
        .rst_n       (rst_n),
        .wake_req    (wake_req),
        .core_pwr_en (core_pwr_en)
    );

    aon_timer u_timer (
        .clk_aon    (clk_aon),
        .rst_n      (rst_n),
        .interval   (interval_from_core),   // isolated output of PD_CORE
        .timer_load (timer_load_from_core), // isolated output of PD_CORE
        .wake_req   (wake_req)              // input to PD_CORE, no isolation
    );


    // PD_CORE: switchable
    ble_baseband u_ble_basedband (
        .clk_core   (clk_core),
        .rst_n_core (rst_n_core)
    );

endmodule