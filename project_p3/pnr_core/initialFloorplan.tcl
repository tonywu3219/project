# Floorplan
floorPlan -site core -s 1100 1100 10 10 10 10

addRing -spacing {top 2 bottom 2 left 2 right 2} -width {top 2 bottom 2 left 2 right 2}  -layer {top M1 bottom M1 left M2 right M2} -center 1 -type core_rings -nets {VSS  VDD}

placeInstance psum_mem_instance 400.0 400.0 R0
placeInstance qmem_instance 50.0 50.0 R0
placeInstance kmem_instance 400.0 50.0 R0

#placeInstance mac_array_instance 50.0 400.0 R0
#placeInstance fifo_inst 50.0 800.0 R0

#flipOrRotateObject -flip MY -name psum_mem_instance

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

#setAddStripeMode -break_at {block_ring}

addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit M1 -max_same_layer_jog_length 0.8 -padcore_ring_bottom_layer_limit M1 -number_of_sets 155 -skip_via_on_pin Standardcell -stacked_via_top_layer M8 -padcore_ring_top_layer_limit M1 -spacing 3 -merge_stripes_value 0.1 -direction horizontal -layer M5 -block_ring_bottom_layer_limit M1 -width 2 -area {} -nets {VDD VSS} -stacked_via_bottom_layer M1

### Note: Change the number of strip  by looking at the layout #########
#addStripe -number_of_sets 32 -direction vertical -spacing 2 -layer M4 -width 2 -nets { VSS VDD }

#################################################

#addStripe -nets {VDD VSS} -layer M4 -direction vertical -width 1.8 -spacing 1.8 -number_of_sets 5 -start_from left -start 80 -stop 180 

sroute


