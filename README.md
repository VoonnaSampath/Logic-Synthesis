# Logic Synthesis (DC) Study – picorv32a (32nm)

## Overview

This repository presents a **comparative Quality of Results (QoR) study** of logic synthesis performed using **Synopsys Design Compiler (DC Shell – Academic Version)** on the **picorv32a RISC-V core**, targeting a **32 nm standard-cell technology**.

The objective is to analyze how **different synthesis strategies, delay models, and PVT corners** impact:

- Timing (WNS / TNS)
- Area
- Power
- Optimization behavior

In addition, this repository demonstrates a **clean, reusable synthesis setup** where the **target library path can be switched using a single variable (`PDKPATH`)**, closely resembling **industry-style DC flows**.

This project is intended for **learning, interview preparation, and practical exposure to real-world synthesis methodologies**.

---

## Design Details

- **RTL**: picorv32a (open-source RISC-V core)
- **Technology Node**: 32 nm
- **Standard Cell Library**: SAED 32nm (educational / academic)
- **Synthesis Tool**: Synopsys Design Compiler (DC Shell – Academic)
- **Constraints**: Single-clock synchronous design (SDC based)

---

## Synthesis Variations Studied

### 1. Delay Models

- **NLDM (Non-Linear Delay Model)**
- **CCS (Composite Current Source)**

### 2. Compile Strategies

- `compile`
- `compile_ultra`
- `compile_incremental`
- `compile_ultra -incremental`

### 3. PVT Corners

- **TT** – Typical / Typical / 25 °C  
- **SS** – Slow / Slow / 125 °C  
- **FF** – Fast / Fast / −40 °C  

---

## Library Path Configuration (PDKPATH)

To enable **easy switching between different target libraries, delay models, and PVT corners**, the synthesis scripts use a **single configurable variable**:

```tcl
set PDKPATH "./ref/saed32"
```

Each PVT corner and delay model is placed in a **separate folder**, for example:

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

By updating only the `PDKPATH` (or selecting a different subfolder), the same synthesis flow can be reused across:

- NLDM vs CCS libraries  
- TT / SS / FF corners  
- Different compile strategies  

This approach mirrors **industry-standard synthesis scripting practices** and avoids hardcoding library paths.

---

## Repository Structure

    Picorv32a/
    ├── rtl/                # picorv32a RTL
    ├── constraints/        # SDC constraints
    ├── scripts/            # DC synthesis scripts
    ├── ref/                # 32nm libraries (organized by model & PVT)
    ├── reports/            # Timing, area, power reports
    ├── comparison/         # QoR summary tables and observations
    └── logs/               # DC Shell logs

---

## QoR Comparison – Delay Model vs Compile Strategy (TT Corner)

| Delay Model | Compile Mode | WNS (ns) | Area (µm²) | Total Power (µW) |
| --- | --- | --- | --- | --- |
| NLDM | compile | -0.31 | 142,800 | 8,920 |
| NLDM | compile_ultra | 0.06 | 149,400 | 9,780 |
| CCS | compile | -0.18 | 145,200 | 9,010 |
| CCS | compile_ultra | 0.11 | 151,600 | 9,960 |

---

## Incremental Compile Impact (CCS, TT Corner)

| Mode | WNS (ns) | Area Change | Observation |
| --- | --- | --- | --- |
| compile_ultra | 0.11 | Baseline | Full re-optimization |
| ultra_incremental | 0.09 | +1.2% | QoR preserved, ECO-friendly |

---

## PVT Corner Timing Comparison (CCS, compile\_ultra)

| Corner | WNS (ns) | Dominant Effect |
| --- | --- | --- |
| TT | 0.11 | Nominal |
| SS | -0.42 | Worst-case setup |
| FF | 0.58 | Best timing, higher leakage |

---

## How to Run the Synthesis

### 1\. Clone the repository

`git clone <repository_link>`
`cd dc-synthesis-qor-study`

### 2\. Ensure library availability

Place the SAED 32nm `.db` files under:

`ref/saed32/`

Example:

`ref/saed32/nldm/tt/saed32rvt_tt0p78vn40c.db`

### 3\. Launch Design Compiler

`dc_shell`

### 4\. Source the DC script

`source scripts/run_dc.tcl`

The script will:

- Set target and link libraries using `PDKPATH`
- Read RTL and constraints
- Run synthesis
- Generate netlist and reports

---

## Outputs Generated

After synthesis, the following are produced:

- Gate-level netlist (`mapped.v`)
- Timing reports
- Area reports
- Power reports
- QoR summary

A consolidated report is also available as:

- Reports of PICORV32a.pdf

---

## Key Observations

- CCS provides **more realistic delay modeling** and improves WNS over NLDM.
- `compile_ultra` achieves timing closure at the cost of **area and power**.
- Incremental compile is well-suited for **ECO-style updates**.
- SS corner dominates **setup timing closure**, while FF corner increases leakage.

---

## Disclaimer

All standard-cell libraries used in this project are **educational / anonymized representations**.  
No proprietary, NDA-restricted, or foundry-confidential data is included.

---

## Motivation

This project was created to gain **hands-on experience with synthesis trade-offs**, scripting practices, and QoR analysis typically encountered in **ASIC design and STA roles**.

---

## Author

**Sampath Voonna**  
Electronics and Communication Engineering  
Interested in VLSI Physical Design, STA, and Logic Synthesis
