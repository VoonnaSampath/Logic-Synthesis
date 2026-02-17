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
- **Operating Point Studied**: `tt0p78vn40`
- **Constraints**: single-clock synchronous SDC flow

---

## Experiment Matrix

For each delay model, synthesis was run in both compile modes:

- `compile`
- `compile_ultra`

For each compile mode, the following VT library combinations were tested at `tt0p78vn40`:

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
    │   └── tt0p78vn40/
    │       ├── rvt/
    │       ├── lvt/
    │       └── hvt/
    └── ccs/
        └── tt0p78vn40/
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

## Repository Structure

```text
.
├── Picorv32a/
│   ├── rtl/                # picorv32a RTL
│   ├── constraints/        # SDC constraints
│   ├── scripts/            # DC synthesis scripts
│   ├── ref/                # SAED32 libraries (NLDM/CCS, VT groups)
│   ├── reports/            # timing/area/power and other run reports
│   └── comparison/         # QoR comparison tables and observations
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

Ensure NLDM and CCS libraries for `RVT/LVT/HVT` at `tt0p78vn40` are available under `ref/saed32/`.

### 3. Launch Design Compiler

```bash
dc_shell
```

### 4. Source synthesis script

```tcl
source scripts/run_dc.tcl
```

The script should be configured to iterate over:

- Delay models: `nldm`, `ccs`
- Compile modes: `compile`, `compile_ultra`
- VT combinations: `RVT`, `RVT+LVT`, `RVT+HVT`, `LVT+HVT`, `RVT+LVT+HVT`

---

## Outputs

Expected outputs per run include:

- Gate-level netlist
- Setup and hold timing reports
- Area, cell, and reference reports
- QoR and power reports
- Clock-tree, wire-load, and VT-group reports

A consolidated comparison document can be maintained in `comparison/`.

---

## Key Objective

The goal is to understand how delay model choice and VT-library mixing influence timing, area, power, and optimization behavior for `picorv32a` at `tt0p78vn40`.

---

## Disclaimer

All standard-cell libraries used in this project are educational/anonymized representations.
No proprietary, NDA-restricted, or foundry-confidential data is included.

---

## Author

**Sampath Voonna**  
Electronics and Communication Engineering  
Interested in VLSI Physical Design, STA, and Logic Synthesis
