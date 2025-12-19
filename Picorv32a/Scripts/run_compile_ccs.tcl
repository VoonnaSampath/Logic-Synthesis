####Script to run Design Compiler with Different Scenarios#####
##
set PDK_PATH /data/pdk/pdk32nm/SAED32_EDK/lib/stdcell_rvt/db_ccs
#
source -echo -verbose ./rm_setup/dc_setup.tcl

#set_svf ${RESULTS_DIR}/${DCRM_SVF_OUTPUT_FILE}
#saif_map -start


set RTL_SOURCE_FILES ./../rtl/picorv32a.v

# To define design lib to store intermediate design files
define_design_lib WORK -path ./WORK

#set_app_var hdlin_enable_hier_map true

#SET_DONT_USE for excluding cells   

#set_dont_use [get_lib_cells */FADD*]
#set_dont_use [get_lib_cells */HADD*]
#set_dont_use [get_lib_cells */MUX*]
#set_dont_use [get_lib_cells */AO*]
#set_dont_use [get_lib_cells */OA*]
#set_dont_use [get_lib_cells */NAND*]
#set_dont_use [get_lib_cells */XOR*]
#set_dont_use [get_lib_cells */NOR*]
#set_dont_use [get_lib_cells */XNOR*]


## Not to USE LVT cell for minimizing leakage power consumption ##
###set_dont_use [get_lib_cells "LowVT_Cell"] -all #########


analyze -format verilog ${RTL_SOURCE_FILES}
elaborate ${DESIGN_NAME}
current_design
#set_verification_top
read_sdc -echo ./../CONSTRAINTS/picorv32a.sdc

#group_path -name INPUT -from [all_inputs]

#group_path -name output -to [all_outputs]

#group_path -name CMBNTL -from [all_inputs] -to [all_outputs]

compile

##"use incremental mapping for both compile and compile_ultra"
#compile_ultra

#report_timing
#report_timin -delay min
#report_qor
#report_power
#report_area

#write results ###
write -format verilog -hierarchy -output ${RESULTS_DIR}/${DCRM_FINAL_VERILOG_OUTPUT_FILE}
write -format ddc -hierarchy -output ${RESULTS_DIR}/${DCRM_FINAL_DDC_OUTPUT_FILE}

#write_sdc ./${RESULTS_DIR}/${DCRM_FINAL_SDC_OUTPUT_FILE}
#
### To Writes the files needed to load the design in IC Compiler II.
##write_icc2_files -output icc2_files -force
#
