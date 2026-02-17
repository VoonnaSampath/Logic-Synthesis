set PDK_PATH ./../ref/saed32/

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


#write results ###
write -format verilog -hierarchy -output ${RESULTS_DIR}/${DCRM_FINAL_VERILOG_OUTPUT_FILE}
write_sdf ./${RESULTS_DIR}/${DCRM_DCT_FINAL_SDF_OUTPUT_FILE}

