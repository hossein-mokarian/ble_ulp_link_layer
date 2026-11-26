
module aon_ctrl (
    input logic clk_aon,
    input logic rst_n,

    input logic wake_req,
    input logic timer_load,
    input logic pwr_good,   // from CORE
    
    output logic core_pwr_en,
    output logic iso_en_core,
    output logic ret_save_n,
    output logic ret_restore_n
);

    typedef enum logic [2:0] {
        IDLE,
        ISO_ON,
        SAVE,
        PWR_OFF,
        PWR_ON,
        RESTORE,
        ISO_OFF
    } aon_ctrl_state_e;

    aon_ctrl_state_e state;


    always_ff @(posedge clk_aon or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (!wake_req && !timer_load) state <= ISO_ON;
                ISO_ON: state <= SAVE;
                SAVE: state <= PWR_OFF;
                PWR_OFF: if (wake_req) state <= PWR_ON;
                PWR_ON: if (pwr_good) state <= RESTORE;
                RESTORE: state <= ISO_OFF;
                ISO_OFF: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        case (state)
            IDLE: begin
                core_pwr_en = 1'b1;
                iso_en_core = 1'b0;
                ret_save_n = 1'b1;
                ret_restore_n = 1'b0;
            end
            ISO_ON: begin
                core_pwr_en = 1'b1;
                iso_en_core = 1'b1;
                ret_save_n = 1'b1;
                ret_restore_n = 1'b0;
            end
            SAVE: begin
                core_pwr_en = 1'b1;
                iso_en_core = 1'b1;
                ret_save_n = 1'b0;
                ret_restore_n = 1'b1;
            end
            PWR_OFF: begin
                core_pwr_en = 1'b0;
                iso_en_core = 1'b1;
                ret_save_n = 1'b0;
                ret_restore_n = 1'b1;
            end
            PWR_ON: begin
                core_pwr_en = 1'b1;
                iso_en_core = 1'b1;
                ret_save_n = 1'b0;
                ret_restore_n = 1'b1;
            end
            RESTORE: begin
                core_pwr_en = 1'b1;
                iso_en_core = 1'b1;
                ret_save_n = 1'b1;
                ret_restore_n = 1'b0;
            end
            ISO_OFF: begin
                core_pwr_en = 1'b1;
                iso_en_core = 1'b0;
                ret_save_n = 1'b1;
                ret_restore_n = 1'b0;
            end
        endcase
    end

endmodule
