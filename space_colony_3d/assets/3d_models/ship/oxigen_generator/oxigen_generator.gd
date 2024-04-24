extends Node3D
@onready var blue_print_controller = $bluePrint_controller
@onready var ship = get_tree().current_scene.base_ship
var state = "pre_build"

func destroy_building():
	queue_free()


func _on_timer_timeout():
	print("oxi timer")
	var oxi_gen_pos =$".".position
	var ATM_cell = ship.get_atm_cell_by_pos(oxi_gen_pos)
	
	print(ATM_cell.oxi)
	
	if ATM_cell.oxi < 200:
		print("emmit")
		ATM_cell.oxi+=50
