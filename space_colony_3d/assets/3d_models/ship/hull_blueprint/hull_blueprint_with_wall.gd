extends Node3D
@onready var ship = get_tree().current_scene.base_ship


func build():
	#print("construir hull")
	$build_detector_Area.remove_from_group("blue_print")
	ship.add_hull_wall($".".global_position)
	queue_free()
	
func write_blueprint():
	#print("write_blueprint")
	
	$build_detector_Area.add_to_group("blue_print")
