
module ble_ll_fsm (
    input  logic clk,
    input  logic rst_n,

    input  logic pkt_start,      // from AON: packet event scheduled
    input  logic pkt_done,       // from datapath: CRC + whitening finished

    input logic tx_data_valid,
    input logic rx_data_valid,
    
    output logic crc_init,
    output logic whit_init,

    output logic  tx_active,      // enable for TX datapath
    output logic  rx_active,      // enable for RX datapath (future)

    output logic [15:0] timer_interval,       // connection interval in AON ticks
    output logic        timer_load,
    output logic        pwr_good
);

    localparam int TIMEOUT = 32'd20;

    typedef enum logic [1:0] {
        STANDBY = 2'b00,
        TX      = 2'b01,
        RX      = 2'b10,
        DONE    = 2'b11
    } state_e;

    state_e state, next_state;

    logic [31:0] tmr_count;

    // State register: enable-gated by state change only
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= STANDBY;
        else
            state <= next_state;
    end

    // Next-state logic (combinational: no clock gating needed)
    always_comb begin
        next_state = state;
        case (state)
            STANDBY: if (pkt_start) next_state = TX;
            TX:      if (pkt_done)  next_state = DONE;
            RX:                     next_state = STANDBY;
            DONE:                   next_state = STANDBY;
            default:                next_state = STANDBY;
        endcase
    end

    // Output enables: these drive the datapath clock gates
    always_comb begin
        crc_init = (state == STANDBY);
        whit_init = (state == STANDBY);
        tx_active = (state == TX);
        rx_active = (state == RX);
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tmr_count <= '0;
        end else if (tx_active && tx_data_valid) begin
            tmr_count <= '0;
        end else if (rx_active && rx_data_valid) begin
            tmr_count <= '0;
        end else if (tx_active && !tx_data_valid) begin
            tmr_count <= tmr_count + 1'b1;
        end else if (rx_active && !rx_data_valid) begin
            tmr_count <= tmr_count + 1'b1;
        end else if (state == STANDBY) begin
            tmr_count = '0;
        end
    end

    assign timer_interval = 16'd20;
    assign timer_load = (state != STANDBY && (tmr_count < TIMEOUT));
    assign pwr_good = 1'b1;

endmodule
