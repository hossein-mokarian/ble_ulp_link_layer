
run_ble_core_tb:
	cd ../tb/unit && \
	iverilog -g2012 -o tb_ble_core.vvp \
		tb_ble_core.sv \
		../../rtl/ble_core_top.sv \
		../../rtl/ble_baseband.sv \
		../../rtl/ble_ll_fsm.sv \
		../../rtl/crc24.sv \
		../../rtl/whitening.sv && \
	vvp tb_ble_core.vvp && \
	gtkwave.exe tb_ble_core.vcd


ble_core_clock_gating:
	yosys -s check_gatable.ys


run_ble_soc_tb:
	cd ../tb/unit && \
	iverilog -g2012 -o tb_ble_soc.vvp \
		tb_ble_soc.sv \
		../../rtl/ble_soc_top.sv \
		../../rtl/aon_ctrl.sv \
		../../rtl/aon_timer.sv \
		../../rtl/ble_baseband.sv \
		../../rtl/ble_ll_fsm.sv \
		../../rtl/crc24.sv \
		../../rtl/whitening.sv && \
	vvp tb_ble_soc.vvp && \
	gtkwave.exe tb_ble_soc.vcd


run_aon_timer_tb:
	cd ../tb/unit && \
	iverilog -g2012 -o tb_aon_timer.vvp \
		tb_aon_timer.sv \
		../../rtl/aon_timer.sv && \
	vvp tb_aon_timer.vvp && \
	gtkwave.exe tb_aon_timer.vcd


run_aon_ctrl_tb:
	cd ../tb/unit && \
	iverilog -g2012 -o tb_aon_ctrl.vvp \
		tb_aon_ctrl.sv \
		../../rtl/aon_ctrl.sv && \
	vvp tb_aon_ctrl.vvp && \
	gtkwave.exe tb_aon_ctrl.vcd


run_power_seq_tb:
	cd ../tb/unit && \
	iverilog -g2012 -o tb_power_seq.vvp \
		tb_power_seq.sv \
		./checker/tb_isolation.sv \
		./checker/tb_retention.sv \
		../../rtl/aon_ctrl.sv && \
	vvp tb_power_seq.vvp && \
	gtkwave.exe tb_power_seq.vcd
