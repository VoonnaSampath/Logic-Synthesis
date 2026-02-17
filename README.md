# Logic Synthesis QoR Study: `picorv32a` on SAED32 (Design Compiler)

## Overview

This repository contains a comparative **Quality of Results (QoR)** study of logic synthesis using **Synopsys Design Compiler (DC Shell, Academic)** on the **`picorv32a` RISC-V core**, targeting **SAED 32nm** libraries.

The study compares how synthesis choices affect:

- Timing (`WNS`, `TNS`)
- Area
- Power
- Optimization behavior across corners

The flow is organized to be reusable and script-friendly: library selection is controlled through a single variable (`PDKPATH`) so the same setup can be reused across delay models and PVT corners.

---

## Design Details

- **RTL**: `picorv32a` (open-source RISC-V core)
- **Technology Node**: 32nm
- **Library**: SAED32 (educational/academic setup)
- **Tool**: Synopsys Design Compiler (`dc_shell`, Academic)
- **Constraints**: single-clock synchronous SDC flow

---

## Study Dimensions

### 1. Delay Models

- **NLDM (Non-Linear Delay Model)**
- **CCS (Composite Current Source)**

### 2. Compile Strategies

- `compile`
- `compile_ultra`
- `compile_incremental`
- `compile_ultra -incremental`

### 3. PVT Corners

- **TT**: Typical / Typical / 25C
- **SS**: Slow / Slow / 125C
- **FF**: Fast / Fast / -40C

---

## Library Configuration (`PDKPATH`)

To switch target libraries, delay models, and PVT corners with minimal script edits, the flow uses a single variable:

```tcl
set PDKPATH "./ref/saed32"
```

Expected organization:

    ref/
    ├── saed32/
    │   ├── nldm/
    │   │   ├── tt/
    │   │   ├── ss/
    │   │   └── ff/
    │   └── ccs/
    │       ├── tt/
    │       ├── ss/
    │       └── ff/

By changing `PDKPATH` (or subfolder selection), the same script supports:

- NLDM vs CCS libraries
- TT / SS / FF corners
- Different compile strategies

This approach mirrors **industry-standard synthesis scripting practices** and avoids hardcoding library paths.

---

## Repository Structure

    .
    ├── rtl/                # picorv32a RTL
    ├── constraints/        # SDC constraints
    ├── scripts/            # DC synthesis scripts
    ├── ref/                # 32nm libraries (organized by model & PVT)
    ├── reports/            # Timing, area, power reports
    ├── comparison/         # QoR summary tables and observations
    └── logs/               # DC Shell logs

---

## QoR Snapshot: Delay Model vs Compile Strategy (TT)

| Delay Model | Compile Mode | WNS (ns) | Area (µm²) | Total Power (µW) |
| --- | --- | --- | --- | --- |
| NLDM | compile | -0.31 | 142,800 | 8,920 |
| NLDM | compile_ultra | 0.06 | 149,400 | 9,780 |
| CCS | compile | -0.18 | 145,200 | 9,010 |
| CCS | compile_ultra | 0.11 | 151,600 | 9,960 |

---

## Incremental Compile Impact (CCS, TT)

| Mode | WNS (ns) | Area Change | Observation |
| --- | --- | --- | --- |
| compile_ultra | 0.11 | Baseline | Full re-optimization |
| compile_ultra -incremental | 0.09 | +1.2% | QoR preserved, ECO-friendly |

---

## PVT Timing Comparison (CCS, `compile_ultra`)

| Corner | WNS (ns) | Dominant Effect |
| --- | --- | --- |
| TT | 0.11 | Nominal |
| SS | -0.42 | Worst-case setup |
| FF | 0.58 | Best timing, higher leakage |

---

## Quick Start

### 1. Clone the repository

```bash
git clone <repository_link>
cd Git-Repo-Logic-Synthesis/Picorv32a
```

### 2. Ensure SAED32 library availability

Place the SAED 32nm `.db` files under:

```text
ref/saed32/
```

Example:

```text
ref/saed32/nldm/tt/saed32rvt_tt0p78vn40c.db
```

### 3. Launch Design Compiler

```bash
dc_shell
```

### 4. Source the synthesis script

```tcl
source scripts/run_dc.tcl
```

The script will:

- Configure target/link libraries using `PDKPATH`
- Read RTL and constraints
- Run synthesis
- Generate netlist and reports

---

## Outputs

After synthesis, the flow generates:

- Gate-level netlist (`mapped.v`)
- Timing reports
- Area reports
- Power reports
- QoR summary

A consolidated report is also included:

- `Reports of PICORV32a.pdf`

---

## Key Observations

- CCS provides more realistic delay modeling and better WNS than NLDM in this study.
- `compile_ultra` improves timing closure, typically at area/power cost.
- Incremental compile is useful for ECO-style updates with small QoR drift.
- SS is the setup-critical corner; FF shows stronger timing with higher leakage tendency.

---

## Disclaimer

All standard-cell libraries used in this project are educational/anonymized representations.  
No proprietary, NDA-restricted, or foundry-confidential data is included.

---

## Motivation

This work focuses on practical synthesis trade-offs, reusable DC scripting, and QoR analysis relevant to ASIC implementation and STA workflows.

---

## Author

**Sampath Voonna**  
Electronics and Communication Engineering  
Interested in VLSI Physical Design, STA, and Logic Synthesis
