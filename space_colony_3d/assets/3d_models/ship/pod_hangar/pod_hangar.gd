extends Node3D
@onready var blue_print_controller = $bluePrint_controller

var state = "pre_build"

func destroy_building():
	queue_free()


func _on_landing_area_body_entered(body):
	print(body)
	pass # Replace with function body.
