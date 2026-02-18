# Logic Synthesis QoR Study: `picorv32a` on SAED32 (Design Compiler)

## Project Summary

This repository documents a practical logic synthesis study on the `picorv32a` RISC-V core using Synopsys Design Compiler (Academic version) with SAED32 libraries.

The work is organized into **two chapters**:

1. **Chapter 1: NLDM vs CCS** (model comparison across the standard synthesis flow)
2. **Chapter 2: SDC with CLK Period < 0.5** (NLDM-only setup worst-case and hold best-case analysis with a new constraint file)

This README is structured to be easy to follow as both a runbook and a report summary.

---

## Common Project Setup

### Design and Tool Context

- RTL design: `picorv32a` (open-source RISC-V core)
- Technology node: 32nm
- Tool: Synopsys Design Compiler (`dc_shell`, Academic version)
- Library families used: SAED32 `RVT`, `LVT`, `HVT`

### Required Environment Files

A required setup directory named `rm_setup` is used by the flow (not included in this repository).

- `rm_setup/common_setup.tcl` is mandatory
- Additional setup files in `rm_setup` are also required
- `target_library` and `link_library` are updated there before each experiment

### Script and Constraint Locations

- Synthesis scripts: `Picorv32a/Scripts/`
- Constraint files: `Picorv32a/CONSTRAINTS/`
- Reports: `Picorv32a/Reports/`

### Post-Compile Report Commands

After compilation, reports are extracted individually from `dc_shell`:

```tcl
report_timing
report_area
report_power
report_cell
report_reference
report_qor
```

To get the total hierarchical cell count:

```tcl
sizeof_collection [get_cells -hierarchical]
```

### Output Artifact

A mapped gate-level netlist is generated after compilation (for example: `picorv32a.mapped.v` in the results output).

---

## Chapter 1: NLDM vs CCS

### Chapter Objective

This chapter compares synthesis behavior between `NLDM` and `CCS` libraries to observe timing, area, power, and cell-count differences under the same compile mode.

### Study Scope and Run Style

- Delay model comparison: `NLDM` vs `CCS`
- Compile focus in summary table: `compile_ultra`
- Constraint reference used in this chapter: `Picorv32a/CONSTRAINTS/picorv32a.sdc`
- VT coverage represented in table rows: `RVT,LVT,HVT`

### Library Path Style

A configurable path variable is used:

```tcl
set PDKPATH "./ref/saed32"
```

Typical structure:

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

### Reports Considered in Chapter 1

- Setup timing
- Hold timing
- Area
- Total power
- Total cell count
- Supporting reports: QoR, reference, clock tree, wire load, VT group

### Chapter 1 Table (NLDM vs CCS, Ultra)

Use this compact table to compare `compile_ultra` runs for `NLDM` and `CCS` with `RVT`, `LVT`, and `HVT`.

| Delay Model | Compile Mode | VT Type | Constraint File | Setup WNS (ns) | Hold WNS (ns) | Area (um^2) | Total Power (uW) | Total Cell Count |
| --- | --- | ------- | --- | --- | --- | --- | --- | --- |
| NLDM | compile_ultra | RVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a.sdc` | 0.00 | 0.21  | 47053.661412  | 1.6858E+03 | 11010  |
| CCS | compile_ultra | RVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a.sdc` | 0.01 | 0.18 | 43790.645626 | 2.6698E+03 | 9219 |

---

## Chapter 2: New SDC Topic (`picorv32a_new.sdc`, NLDM Only)

### Chapter Objectives

This chapter focuses on a new constraint-driven analysis to explicitly capture:

- **Worst-case setup behavior** (maximum path delay stress)
- **Best-case hold behavior** (minimum delay stress)

This chapter uses **NLDM libraries only**.

### Constraint File Used

- `Picorv32a/CONSTRAINTS/picorv32a_new.sdc`

### 1. Worst-Case (Setup Check) Target Library Intent

Used to catch maximum path delay violations.

Corner options:

```text
ss_vmin_125c.db    ss_vnom_125c.db    tt_vmin_125c.db
```

Full NLDM library set used:

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

Used to evaluate hold under fastest corner tendency.

Corner options:

```text
ff_vmax_m40c.db    ff_vnom_m40c.db    tt_vmax_m40c.db
```

Full NLDM library set used:

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

### Run Notes for Chapter 2

- Apply `picorv32a_new.sdc`
- Update NLDM target/link library setup in `rm_setup/common_setup.tcl` and related setup files
- Run synthesis (`compile` / `compile_ultra`) and extract setup, hold, area, power, QoR, and cell reports

### Chapter 2 Table (NLDM Multi-Constraint)

You also ran additional NLDM experiments for `RVT`, `LVT`, and `HVT` using different constraints. Use this template:

| Delay Model | Mode | VT Type | Constraint File | Setup WNS (ns) | Hold WNS (ns) | Total Cell Count |
| --- | --- | ------- | --- | --- | --- | --- |
| NLDM | Worst Setup | RVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a_new.sdc` | -2.17 | - | 12509 |
| NLDM | Best Hold | RVT,LVT,HVT | `Picorv32a/CONSTRAINTS/picorv32a_new.sdc` | -  | 0.05 | 14980  |

---

## How to Run (Practical Steps)

1. Clone and enter the project:

```bash
git clone <repository_link>
cd Git-Repo-Logic-Synthesis/Picorv32a
```

1. Ensure `.db` libraries are available for the selected model/corners/VTs.
2. Open DC shell:

```bash
dc_shell
```

1. Source the required scripts based on the experiment:

```tcl
source Picorv32a/Scripts/run_compile_nldm.tcl
source Picorv32a/Scripts/run_ultra_nldm.tcl
source Picorv32a/Scripts/run_compile_ccs.tcl
source Picorv32a/Scripts/run_ultra_ccs.tcl
source Picorv32a/Scripts/run_new_sdc.tcl
```

1. Before each run, update:

- `rm_setup/common_setup.tcl` and related setup files
- Constraint file selection (`picorv32a.sdc` or `picorv32a_new.sdc`)

---

## Repository Structure

```text
.
├── Picorv32a/
│   ├── rtl/                # picorv32a RTL
│   ├── CONSTRAINTS/        # SDC files (including added constraint files)
│   ├── Scripts/            # DC synthesis scripts
│   ├── ref/                # SAED32 libraries (NLDM/CCS, VT groups)
│   └── Reports/            # timing/area/power and other run reports
├── rm_setup/               # required setup (not included in this repo)
├── README.md
└── LICENSE
```

---

## Key Objective

The objective is to understand how delay-model choice and constraint strategy impact timing, area, power, and cell usage for `picorv32a` in a practical synthesis flow.

---

## Disclaimer

All standard-cell libraries in this project are educational/anonymized representations.
No proprietary, NDA-restricted, or foundry-confidential data is included.

---

## Author

**Sampath Voonna**  
Electronics and Communication Engineering  
Interested in VLSI Physical Design, STA, and Logic Synthesis
