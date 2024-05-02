extends Node3D
const _3X_3_WALL_01 = preload("res://assets/3d_models/ship/hull_modules/3x3 wall/3x3 wall01.glb")
const THIN_WALL_01 = preload("res://assets/3d_models/ship/hull_modules/3x3 wall/thin/thin_wall_01.glb")
@onready var wall_object = $wall_object

func build_wall():
	wall_object.add_child(THIN_WALL_01.instantiate())
	$internal_wall.set_collision_layer_value(1,true)
	
func show_blueprint():
	$MeshInstance3D.visible = true
	$Timer.start()

func _on_timer_timeout():
	$MeshInstance3D.visible = false
	
