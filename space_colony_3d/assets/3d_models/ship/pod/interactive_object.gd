extends Area3D

@onready var animation_player = $"../AnimationPlayer"

# Called when the node enters the scene tree for the first time.
func use_object():
	print()
	animation_player.play("button_press")
	$"..".lunch_pod()
