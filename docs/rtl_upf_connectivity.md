# RTL + UPF Connectivity Map

## PD_CORE → PD_AON Crossings

| Signal | Source (PD_CORE) | Destination (PD_AON) | Isolation | Control | Control Source Domain |
|---|---|---|---|---|---|
| timer_interval[15:0] | u_ble_baseband | u_aon_timer | iso_core_out | iso_en_core | PD_AON (u_aon_ctrl) |
| timer_load | u_ble_baseband | u_aon_timer | iso_core_out | iso_en_core | PD_AON (u_aon_ctrl) |
| crc_out[23:0] | u_crc | (debug/test) | iso_core_out | iso_en_core | PD_AON (u_aon_ctrl) |

## PD_AON → PD_CORE Crossings

| Signal | Source (PD_AON) | Destination (PD_CORE) | Isolation Required? | Reason |
|---|---|---|---|---|
| wake_req | u_aon_ctrl | u_fsm | **No** | Input to gated domain; always driven by ON domain |
| clk_aon | (clock source) | u_ble_baseband | **No** | Clock input; valid when PD_CORE is powered |
| core_pwr_en | u_aon_ctrl | power switch | N/A | Supply control, not data |

## Isolation Control Reachability

- `iso_en_core`: generated in `u_aon_ctrl` (PD_AON). Must reach isolation cell enable pins on all PD_CORE outputs.
- **finding**: PASS (generated in PD_AON).

## Retention Control Reachability

- `ret_save_n`: generated in `u_aon_ctrl` (PD_AON). Must reach retention register save pins.
- `ret_restore_n`: generated in `u_aon_ctrl` (PD_AON). Must reach retention register restore pins.