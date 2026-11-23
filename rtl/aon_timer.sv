
module aon_timer (
    input  logic        clk_aon,        // 32 kHz, always on
    input  logic        rst_n,

    input  logic [15:0] interval,       // connection interval in AON ticks
    input  logic        timer_load,     // from PD_CORE after connection setup
    
    output logic        wake_req        // single-cycle pulse to aon_ctrl
);

    logic [15:0] counter;

    always_ff @(posedge clk_aon or negedge rst_n) begin
        if (!rst_n) begin
            counter  <= 16'd0;
            wake_req <= 1'b0;
        end else if (timer_load) begin
            counter  <= interval;
            wake_req <= 1'b0;
        end else if (counter == 16'd1) begin
            counter  <= interval;
            wake_req <= 1'b1;           // one-cycle pulse
        end else begin
            counter  <= counter - 1'b1;
            wake_req <= 1'b0;
        end
    end

endmodule
