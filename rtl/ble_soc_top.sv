
module ble_soc_top (
    input logic         clk_aon,
    input logic         rst_n,

    input logic         clk_core,
    input logic         rst_n_core,

    input logic         pkt_start,
    input logic         pkt_done,
    input logic [6:0]   whit_seed,
    input logic         tx_bit,
    input logic         tx_data_valid,
    input logic         rx_bit,
    input logic         rx_data_valid,

    output logic [23:0] crc_out,
    output logic        whitened_out,

    output logic        core_pwr_en,
    output logic        iso_en_core,
    output logic        ret_save_n,
    output logic        ret_restore_n
);

    logic [15:0] timer_interval;
    logic timer_load;
    logic pwr_good;


    // PD_AON domain: always powered
    aon_ctrl u_aon_ctrl (
        .clk_aon       (clk_aon),
        .rst_n         (rst_n),

        .wake_req      (wake_req),
        .timer_load    (timer_load),
        .pwr_good      (pwr_good),
        
        .core_pwr_en   (core_pwr_en),
        .iso_en_core   (iso_en_core),
        .ret_save_n    (ret_save_n),
        .ret_restore_n (ret_restore_n)
    );

    aon_timer u_aon_timer (
        .clk_aon    (clk_aon),
        .rst_n      (rst_n),
        .interval   (timer_interval),   // isolated output of PD_CORE
        .timer_load (timer_load),       // isolated output of PD_CORE
        .wake_req   (wake_req)          // input to PD_CORE, no isolation
    );


    // PD_CORE: switchable
    ble_baseband u_ble_baseband (
        .clk_core      (clk_core),
        .rst_n_core    (rst_n_core),

        .pkt_start     (pkt_start),
        .pkt_done      (pkt_done),
        .whit_seed     (whit_seed),
        .tx_bit        (tx_bit),
        .tx_data_valid (tx_data_valid),
        .rx_bit        (rx_bit),
        .rx_data_valid (rx_data_valid),

        .crc_out       (crc_out),
        .whitened_out  (whitened_out),

        .timer_interval (timer_interval),
        .timer_load     (timer_load),
        .pwr_good       (pwr_good)
    );

endmodule
