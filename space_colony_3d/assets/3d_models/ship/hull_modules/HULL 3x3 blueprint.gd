extends Node3D
@onready var ship = get_tree().current_scene.base_ship


func write_blueprint():
	pass

func build_blueprint():
	print("build bluasdasds",$".")
	ship.add_hull_wall($".".global_position)
	queue_free()
