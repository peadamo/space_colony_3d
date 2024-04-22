extends Node3D
@onready var blue_print_controller = $bluePrint_controller
@onready var ship = get_tree().current_scene.base_ship
var state = "pre_build"

func destroy_building():
	queue_free()


func _on_landing_area_body_entered(body):
	print(body)
	pass # Replace with function body.

func player_exit_pod():
	ship.free_player($objecet_props/player_exit.global_position)
