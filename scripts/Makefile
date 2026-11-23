
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
