getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
# where is sum in

editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Left -layer 3 -spreadType center -spacing 4 -pin {clk {inst[0]} {inst[1]} {inst[2]} {inst[3]} {inst[4]} {inst[5]} {inst[6]} {inst[7]} {inst[8]} {inst[9]} {inst[10]} {inst[11]} {inst[12]} {inst[13]} {inst[14]} {inst[15]} {inst[16]} {inst[17]} {inst[18]} reset }

checkPinAssignment
