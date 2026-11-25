
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
