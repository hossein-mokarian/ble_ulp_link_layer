# Power Architecture Audit

## Q1: Does any PD_AON output pass through PD_CORE combinational logic before returning to PD_AON?
- Audit all PD_AON → PD_CORE → PD_AON paths.
- If yes: this path is functionally dead when PD_CORE is OFF (only isolation clamp reaches the AON input).
- **Finding**: ["none found"]

## Q2: Is iso_en_core asserted BEFORE core_pwr_en de-asserts?
- Check aon_ctrl state machine.
- **Finding**: [yes, with state sequence]

## Q3: Is ret_save_n pulsed BEFORE core_pwr_en de-asserts?
- **Finding**: [yes]

## Q4: Are all PD_CORE outputs listed in set_isolation -applies_to outputs?
- List: [enumerate every PD_CORE output signal]
- **Finding**: [all covered / missing X]

## Q5: Does VDD_CORE appear in both ON and OFF states of the PST?
- **Finding**: [yes]