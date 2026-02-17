# Logic Synthesis QoR Study: `picorv32a` on SAED32 (Design Compiler)

## Overview

This repository presents a comparative **Quality of Results (QoR)** study of logic synthesis using **Synopsys Design Compiler (DC Shell, Academic version)** on the **`picorv32a` RISC-V core** in **SAED 32nm**.

The flow is built to evaluate how QoR changes with:

- Delay model (`NLDM` vs `CCS`)
- Compile mode (`compile` vs `compile_ultra`)
- Voltage-threshold library combinations (`RVT`, `LVT`, `HVT`)

---

## Design Details

- **RTL**: `picorv32a` (open-source RISC-V core)
- **Technology Node**: 32nm
- **Libraries**: SAED32 (`RVT`, `LVT`, `HVT` views)
- **Tool**: Synopsys Design Compiler (`dc_shell`, Academic version)
- **Operating Point Studied**: `tt0p78vn40c`
- **Constraints**: single-clock synchronous SDC flow

---

## Required Environment Files

This project also depends on a required setup folder named `rm_setup` (not included in this repository).

- `rm_setup/common_setup.tcl` is mandatory
- Additional setup files inside `rm_setup` are also used
- Target/link library combinations are updated in these setup files

Without `rm_setup`, the synthesis scripts are not fully runnable.

---

## New Constraint Methodology (`picorv32a_new.sdc`, NLDM Only)

With the new `.sdc` constraint file, the objective is:

- **Worst-case setup check**: capture maximum path delay violations
- **Best-case hold check**: validate minimum delay/hold safety

This specific flow uses **NLDM libraries only** (`RVT`, `LVT`, `HVT`).

### 1. Worst-Case (Setup Check) Library Intent

Corner options used for setup analysis:

```text
ss_vmin_125c.db    ss_vnom_125c.db    tt_vmin_125c.db
```

Full NLDM library list used for worst-case setup:

```tcl
$PDK_PATH/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p7v125c.db \
$PDK_PATH/lib/stdcell_rvt/db_nldm/saed32rvt_ss0p7v125c.db \
$PDK_PATH/lib/stdcell_rvt/db_nldm/saed32rvt_tt0p78v125c.db \
$PDK_PATH/lib/stdcell_lvt/db_nldm/saed32lvt_ss0p7v125c.db \
$PDK_PATH/lib/stdcell_lvt/db_nldm/saed32lvt_ss0p75v125c.db \
$PDK_PATH/lib/stdcell_lvt/db_nldm/saed32lvt_tt0p78v125c.db \
$PDK_PATH/lib/stdcell_hvt/db_nldm/saed32hvt_ss0p7v125c.db \
$PDK_PATH/lib/stdcell_hvt/db_nldm/saed32hvt_ss0p75v125c.db \
$PDK_PATH/lib/stdcell_hvt/db_nldm/saed32hvt_tt0p78v125c.db
```

### 2. Best-Case (Hold Check) Min Library Intent

Corner options used for hold analysis:

```text
ff_vmax_m40c.db    ff_vnom_m40c.db    tt_vmax_m40c.db
```

Full NLDM library list used for best-case hold:

```tcl
$PDK_PATH/lib/stdcell_rvt/db_nldm/saed32rvt_ff1p16vn40c.db \
$PDK_PATH/lib/stdcell_rvt/db_nldm/saed32rvt_ff0p95vn40c.db \
$PDK_PATH/lib/stdcell_rvt/db_nldm/saed32rvt_tt1p05vn40c.db \
$PDK_PATH/lib/stdcell_lvt/db_nldm/saed32lvt_ff1p16vn40c.db \
$PDK_PATH/lib/stdcell_lvt/db_nldm/saed32lvt_ff0p95vn40c.db \
$PDK_PATH/lib/stdcell_lvt/db_nldm/saed32lvt_tt1p05vn40c.db \
$PDK_PATH/lib/stdcell_hvt/db_nldm/saed32hvt_ff1p16vn40c.db \
$PDK_PATH/lib/stdcell_hvt/db_nldm/saed32hvt_ff0p95vn40c.db \
$PDK_PATH/lib/stdcell_hvt/db_nldm/saed32hvt_tt1p05vn40c.db
```

### Constraint + Library Setup Notes

- Use `Picorv32a/CONSTRAINTS/picorv32a_new.sdc` for this run
- Update `target_library`/`link_library` in `rm_setup/common_setup.tcl` and related `rm_setup` files
- Run synthesis and then extract setup/hold/area/power/cell/QoR reports for comparison

---

## Experiment Matrix

For each delay model, synthesis was run in both compile modes:

- `compile`
- `compile_ultra`

For each compile mode, the following VT library combinations were tested at `tt0p78vn40c`:

1. `RVT`
2. `RVT + LVT`
3. `RVT + HVT`
4. `LVT + HVT`
5. `RVT + LVT + HVT`

Execution order followed:

1. Run full matrix with **NLDM** libraries
2. Run full matrix with **CCS** libraries

---

## Library Configuration (`PDKPATH`)

The synthesis scripts use a configurable path variable:

```tcl
set PDKPATH "./ref/saed32"
```

Typical library organization:

```text
ref/
└── saed32/
    ├── nldm/
    │   └── tt0p78vn40c/
    │       ├── rvt/
    │       ├── lvt/
    │       └── hvt/
    └── ccs/
        └── tt0p78vn40c/
            ├── rvt/
            ├── lvt/
            └── hvt/
```

By selecting different `target_library`/`link_library` combinations from these folders, the same script supports all five VT-group experiments.

---

## Reports Collected

For every run (delay model + compile mode + VT combination), the following reports were captured:

- Timing (setup)
- Timing (hold)
- Area
- Cells
- Reference
- QoR
- Power
- Clock tree
- Wire load
- Voltage-threshold group

---

## Post-Compile Report Extraction

After compilation, extract reports individually from `dc_shell`:

```tcl
report_timing
report_area
report_power
report_cell
report_reference
report_qor
```

To get the total number of hierarchical cells:

```tcl
sizeof_collection [get_cells -hierarchical]
```

---

## Results Table Template (Ultra Only)

Use this compact table to compare `compile_ultra` runs for `NLDM` and `CCS` with `RVT`, `LVT`, and `HVT`.

| Delay Model | Compile Mode | VT Type | Constraint File | Setup WNS (ns) | Hold WNS (ns) | Area (um^2) | Total Power (uW) | Total Cell Count |
| --- | --- | ------- | --- | --- | --- | --- | --- | --- |
| NLDM | compile_ultra | RVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a.sdc` |  |  |  |  |  |
| CCS | compile_ultra | RVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a.sdc` |  |  |  |  |  |

---

## NLDM Multi-Constraint Template (RVT/LVT/HVT)

You also ran additional NLDM experiments for `RVT`, `LVT`, and `HVT` using different constraints. Use this template:

| Delay Model | Compile Mode | VT Type | Constraint File | Setup WNS (ns) | Hold WNS (ns) | Area (um^2) | Total Power (uW) | Total Cell Count |
| --- | --- | ------- | --- | --- | --- | --- | --- | --- |
| NLDM | compile | RRVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a_new.sdc` |  |  |  |  |  |
| NLDM | compile_ultra | RVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a_new.sdc` |  |  |  |  |  |

---

## Repository Structure

```text
.
├── Picorv32a/
│   ├── rtl/                # picorv32a RTL
│   ├── CONSTRAINTS/        # SDC files (including added constraint files)
│   ├── Scripts/            # DC synthesis scripts
│   ├── ref/                # SAED32 libraries (NLDM/CCS, VT groups)
│   └──  Reports/            # timing/area/power and other run reports
├── rm_setup/               # required setup (not included in this repo)
├── README.md
└── LICENSE
```

---

## How to Run

### 1. Clone and enter the project

```bash
git clone <repository_link>
cd Git-Repo-Logic-Synthesis/Picorv32a
```

### 2. Place SAED32 `.db` libraries

Ensure NLDM and CCS libraries for `RVT/LVT/HVT` at `tt0p78vn40c` are available under `ref/saed32/`.

### 3. Launch Design Compiler

```bash
dc_shell
```

### 4. Source synthesis script

```tcl
source Picorv32a/Scripts/run_compile_nldm.tcl
```

Run the required scripts as needed:

- `source Picorv32a/Scripts/run_compile_nldm.tcl`
- `source Picorv32a/Scripts/run_ultra_nldm.tcl`
- `source Picorv32a/Scripts/run_compile_ccs.tcl`
- `source Picorv32a/Scripts/run_ultra_ccs.tcl`

Before running, update the target/link library selections in `rm_setup/common_setup.tcl`, related `rm_setup` files along with the CONSTRAINT file `.sdc` .

For the new setup/hold corner experiment, use `Picorv32a/CONSTRAINTS/picorv32a_new.sdc` with the NLDM library sets described above.

---

## Outputs

Expected outputs per run include:

- A mapped gate-level netlist file  (`picorv32a.mapped.v`) in the folder results.
- Setup and hold timing reports
- Area, cell, and reference reports
- QoR and power reports
- Clock-tree, wire-load, and VT-group reports


---

## Key Objective

The goal is to understand how delay model choice and VT-library mixing influence timing, area, power, and optimization behavior for `picorv32a` at `tt0p78vn40c`.

---

## Disclaimer

All standard-cell libraries used in this project are educational/anonymized representations.
No proprietary, NDA-restricted, or foundry-confidential data is included.

---

## Author

**Sampath Voonna**  
Electronics and Communication Engineering  
Interested in VLSI Physical Design, STA, and Logic Synthesis
