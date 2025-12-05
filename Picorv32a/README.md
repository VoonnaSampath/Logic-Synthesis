# PicoRV32A – Logic Synthesis using Synopsys Design Compiler (Academic Version)

This repository contains the **logic synthesis setup and scripts** used to synthesize the **PicoRV32A RISC-V core** using **Synopsys Design Compiler (DC Shell – Academic)** with the **SAED 32nm standard cell library**.

The project demonstrates a complete ASIC synthesis flow using:

- `saed32rvt_tt0p78vn40c.db` - Target library
- `run_dc.tcl` - main DC flow script  
- `picorv32a.v` - RTL  
- `picorv32a.sdc` - Design constraints  

## 🚀 What This Project Does

This flow:

1. Reads the PicoRV32A RTL  
2. Loads the SAED 32nm library  
3. Applies timing constraints (`.sdc`)  
4. Runs synthesis using DC Shell  
5. Generates:
   - Gate-level netlist (`.v`)
   - Timing/area/power reports
   - Mapped synthesized design

## 🛠️ Prerequisites

### Software

- Synopsys **Design Compiler (Academic Version)**
- Linux environment
- Terminal access

### Libraries

- **SAED32** 32nm library  
  → specifically: `saed32rvt_tt0p78vn40c.db`

- Place the library file here:
  → ref/saed32rvt_tt0p78vn40c.db

## ▶️ How I Ran the Synthesis

I followed these steps:

### 1. Open DC Shell

'dc_shell'

### 2. Source the synthesis script

'source run_dc.tcl'

The script automatically:

- Sets the target library  
- Reads the RTL  
- Applies SDC constraints  
- Runs `compile_ultra`  
- Generates netlist + reports  

## 📌 How YOU Can Run This Repository

### 1. Clone the repo

'git clone <this_repositiry_link>'
'cd "repo_name"'

### 2. Ensure SAED32 library is available

'ref/saed32rvt_tt0p78vn40c.db'

### 3. Launch DC Shell

'dc_shell'

### 4. Source the synthesis script

'source run_dc.tcl'

### 5. Check Outputs

After synthesis, check:

out/

- gate-level netlist
- area_report.rpt
- timing_report.rpt
- power_report.rpt
- qor.rpt

## 🧠 Notes

- Compatible with the **Academic** version of DC.  
- Ensure your SAED32 library paths are correct.  
- You can later extend this project with multi-corner libraries or DFT.

## ⭐ If you find this useful

Give the repository a **star ⭐** and connect on LinkedIn!
