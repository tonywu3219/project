#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Mar 22 17:40:41 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v15.23-s045_1 (64bit) 04/22/2016 12:32 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 15.23-s045_1 NR160414-1105/15_23-UB (database version 2.30, 317.6.1) {superthreading v1.26}
#@(#)CDS: AAE 15.23-s014 (64bit) 04/22/2016 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 15.23-s022_1 () Apr 22 2016 09:38:45 ( )
#@(#)CDS: SYNTECH 15.23-s008_1 () Apr 12 2016 21:52:59 ( )
#@(#)CDS: CPE v15.23-s045
#@(#)CDS: IQRC/TQRC 15.1.4-s213 (64bit) Tue Feb  9 17:31:28 PST 2016 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
set init_pwr_net VDD
set init_gnd_net VSS
set init_verilog ./core.out.v
set init_design_netlisttype Verilog
set init_design_settop 1
set init_top_cell core
set init_lef_file {/home/linux/ieng6/ee260bwi25/public/PDKdata/lef/tcbn65gplus_8lmT2.lef ./subckt/sram_w16_64b.lef ./subckt/sram_w16_160b.lef}
create_library_set -name WC_LIB -timing "$worst_timing_lib ./subckt/sram_w16_64b_WC.lib ./subckt/sram_w16_160b_WC.lib"
create_library_set -name BC_LIB -timing "$best_timing_lib ./subckt/sram_w16_64b_BC.lib ./subckt/sram_w16_160b_BC.lib"
create_rc_corner -name Cmax -cap_table $worst_captbl -T 125
create_rc_corner -name Cmin -cap_table $best_captbl -T -40
create_delay_corner -name WC -library_set WC_LIB -rc_corner Cmax
create_delay_corner -name BC -library_set BC_LIB -rc_corner Cmin
create_constraint_mode -name CON -sdc_file [list $sdc]
create_analysis_view -name WC_VIEW -delay_corner WC -constraint_mode CON
create_analysis_view -name BC_VIEW -delay_corner BC -constraint_mode CON
init_design -setup WC_VIEW -hold BC_VIEW
set_interactive_constraint_modes {CON}
setDesignMode -process 65
floorPlan -site core -s 1100 1100 10 10 10 10
addRing -spacing {top 2 bottom 2 left 2 right 2} -width {top 2 bottom 2 left 2 right 2} -layer {top M1 bottom M1 left M2 right M2} -center 1 -type core_rings -nets {VSS  VDD}
setObjFPlanBox Instance kmem_instance 42.935 399.9755 332.935 689.9755
setObjFPlanBox Instance qmem_instance 53.708 752.784 343.708 1042.784
setObjFPlanBox Instance psum_mem_instance 389.855 396.203 1059.855 1066.203
setObjFPlanBox Module mac_array_instance 432.429 36.558 743.029 347.958
setObjFPlanBox Module ofifo_inst 771.3905 75.8895 1016.9905 320.6895
addHaloToBlock {3 3 3 3} qmem_instance
addHaloToBlock {3 3 3 3} kmem_instance
addHaloToBlock {3 3 3 3} psum_mem_instance
timeDesign -preplace -prefix preplace
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
addRing -nets {VDD VSS} -type block_rings -around each_block -layer {top M3 bottom M3 left M2 right M2} -width {top 2 bottom 2 left 2 right 2} -spacing {top 1 bottom 1 left 1 right 1}
globalNetConnect VDD -type pgpin -pin VDD -sinst qmem_instance -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst qmem_instance -verbose -override
globalNetConnect VDD -type pgpin -pin VDD -sinst kmem_instance -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst kmem_instance -verbose -override
globalNetConnect VDD -type pgpin -pin VDD -sinst psum_mem_instance -verbose -override
globalNetConnect VSS -type pgpin -pin VSS -sinst psum_mem_instance -verbose -override
addStripe -nets {VDD VSS} -layer M5 -direction horizontal -width 2 -spacing 3 -number_of_sets 100
sroute
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection counterclockwise -side Bottom -layer 2 -spreadType center -spacing 4 -pin {{mem_in[0]} {mem_in[1]} {mem_in[2]} {mem_in[3]} {mem_in[4]} {mem_in[5]} {mem_in[6]} {mem_in[7]} {mem_in[8]} {mem_in[9]} {mem_in[10]} {mem_in[11]} {mem_in[12]} {mem_in[13]} {mem_in[14]} {mem_in[15]} {mem_in[16]} {mem_in[17]} {mem_in[18]} {mem_in[19]} {mem_in[20]} {mem_in[21]} {mem_in[22]} {mem_in[23]} {mem_in[24]} {mem_in[25]} {mem_in[26]} {mem_in[27]} {mem_in[28]} {mem_in[29]} {mem_in[30]} {mem_in[31]} {mem_in[32]} {mem_in[33]} {mem_in[34]} {mem_in[35]} {mem_in[36]} {mem_in[37]} {mem_in[38]} {mem_in[39]} {mem_in[40]} {mem_in[41]} {mem_in[42]} {mem_in[43]} {mem_in[44]} {mem_in[45]} {mem_in[46]} {mem_in[47]} {mem_in[48]} {mem_in[49]} {mem_in[50]} {mem_in[51]} {mem_in[52]} {mem_in[53]} {mem_in[54]} {mem_in[55]} {mem_in[56]} {mem_in[57]} {mem_in[58]} {mem_in[59]} {mem_in[60]} {mem_in[61]} {mem_in[62]} {mem_in[63]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 4.0 -pin {{inst[0]} {inst[1]} {inst[2]} {inst[3]} {inst[4]} {inst[5]} {inst[6]} {inst[7]} {inst[8]} {inst[9]} {inst[10]} {inst[11]} {inst[12]} {inst[13]} {inst[14]} {inst[15]} {inst[16]} clk reset}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Top -layer 2 -spreadType center -spacing 4.0 -pin {{out[0]} {out[1]} {out[2]} {out[3]} {out[4]} {out[5]} {out[6]} {out[7]} {out[8]} {out[9]} {out[10]} {out[11]} {out[12]} {out[13]} {out[14]} {out[15]} {out[16]} {out[17]} {out[18]} {out[19]} {out[20]} {out[21]} {out[22]} {out[23]} {out[24]} {out[25]} {out[26]} {out[27]} {out[28]} {out[29]} {out[30]} {out[31]} {out[32]} {out[33]} {out[34]} {out[35]} {out[36]} {out[37]} {out[38]} {out[39]} {out[40]} {out[41]} {out[42]} {out[43]} {out[44]} {out[45]} {out[46]} {out[47]} {out[48]} {out[49]} {out[50]} {out[51]} {out[52]} {out[53]} {out[54]} {out[55]} {out[56]} {out[57]} {out[58]} {out[59]} {out[60]} {out[61]} {out[62]} {out[63]} {out[64]} {out[65]} {out[66]} {out[67]} {out[68]} {out[69]} {out[70]} {out[71]} {out[72]} {out[73]} {out[74]} {out[75]} {out[76]} {out[77]} {out[78]} {out[79]} {out[80]} {out[81]} {out[82]} {out[83]} {out[84]} {out[85]} {out[86]} {out[87]} {out[88]} {out[89]} {out[90]} {out[91]} {out[92]} {out[93]} {out[94]} {out[95]} {out[96]} {out[97]} {out[98]} {out[99]} {out[100]} {out[101]} {out[102]} {out[103]} {out[104]} {out[105]} {out[106]} {out[107]} {out[108]} {out[109]} {out[110]} {out[111]} {out[112]} {out[113]} {out[114]} {out[115]} {out[116]} {out[117]} {out[118]} {out[119]} {out[120]} {out[121]} {out[122]} {out[123]} {out[124]} {out[125]} {out[126]} {out[127]} {out[128]} {out[129]} {out[130]} {out[131]} {out[132]} {out[133]} {out[134]} {out[135]} {out[136]} {out[137]} {out[138]} {out[139]} {out[140]} {out[141]} {out[142]} {out[143]} {out[144]} {out[145]} {out[146]} {out[147]} {out[148]} {out[149]} {out[150]} {out[151]} {out[152]} {out[153]} {out[154]} {out[155]} {out[156]} {out[157]} {out[158]} {out[159]}}
setPinAssignMode -pinEditInBatch true
checkPinAssignment
saveDesign floorplan.enc
setPlaceMode -timingDriven true -reorderScan false -congEffort medium -modulePlan True -placeIOPins False
setOptMode -effort high -powerEffort high -leakageToDynamicRatio 0.5 -fixFanoutLoad true -restruct true -verbose true
place_opt_design
saveDesign placement.enc
set_ccopt_property -update_io_latency false
create_ccopt_clock_tree_spec -file ./constraints/core.ccopt
ccopt_design
set_propagated_clock [all_clocks]
optDesign -postCTS -hold
saveDesign cts.enc
setNanoRouteMode -quiet -drouteAllowMergedWireAtPin false
setNanoRouteMode -quiet -drouteFixAntenna true
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true
setNanoRouteMode -quiet -routeSiEffort medium
setNanoRouteMode -quiet -routeWithSiPostRouteFix false
setNanoRouteMode -quiet -drouteAutoStop true
setNanoRouteMode -quiet -routeSelectedNetOnly false
setNanoRouteMode -quiet -drouteStartIteration default
routeDesign
setExtractRCMode -engine postRoute
extractRC
setAnalysisMode -analysisType onChipVariation -cppr both
optDesign -postRoute -setup -hold
optDesign -postRoute -drv
optDesign -postRoute -inc
saveDesign route.enc
verifyGeometry
verifyConnectivity
report_timing -max_paths 100 > ${design}.post_route.timing.rpt
report_power -outfile core.post_route.power.rpt
summaryReport -nohtml -outfile core.post_route.summary.rpt
streamOut core.gds2 -merge {./subckt/sram_w16_64b.gds2 ./subckt/sram_w16_160b.gds2}
write_lef_abstract core.lef
defOut -netlist -routing core.def
saveNetlist core.pnr.v
setAnalysisMode -setup
set_analysis_view -setup WC_VIEW -hold WC_VIEW
do_extract_model -view WC_VIEW -format dotlib ${design}_WC.lib
write_sdf -view WC_VIEW ${design}_WC.sdf
setAnalysisMode -hold
set_analysis_view -setup BC_VIEW -hold BC_VIEW
do_extract_model -view BC_VIEW -format dotlib ${design}_BC.lib
write_sdf -view BC_VIEW ${design}_BC.sdf
