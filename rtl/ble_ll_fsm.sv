
module ble_ll_fsm (
    input  logic clk,
    input  logic rst_n,

    input  logic pkt_start,      // from AON: packet event scheduled
    input  logic pkt_done,       // from datapath: CRC + whitening finished
    
    output logic crc_init,
    output logic whit_init,
    output logic  tx_active,      // enable for TX datapath
    output logic  rx_active       // enable for RX datapath (future)
);

    typedef enum logic [1:0] {
        STANDBY = 2'b00,
        TX      = 2'b01,
        RX      = 2'b10,
        DONE    = 2'b11
    } state_e;

    state_e state, next_state;

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
            DONE:                   next_state = STANDBY;
            RX:                     next_state = STANDBY;
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

endmodule
