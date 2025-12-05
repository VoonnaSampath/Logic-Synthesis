set PDK_PATH ./../ref/lib/stdcell_rvt

source -echo -verbose ./rm_setup/dc_setup.tcl

set RTL_SOURCE_FILES ./../rtl/picorv32a.v

# To define design lib to store intermediate design files
define_design_lib WORK -path ./WORK

analyze -format verilog ${RTL_SOURCE_FILES}
elaborate ${DESIGN_NAME}
current_design

#set_verification_top
read_sdc -echo ./../CONSTRAINTS/picorv32a.sdc

compile

report_timing
report_timin -delay min
report_qor
report_power
report_area

#write results ###
write -format verilog -hierarchy -output ${RESULTS_DIR}/${DCRM_FINAL_VERILOG_OUTPUT_FILE}
