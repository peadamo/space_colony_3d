extends Control
@export var console_controller : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_2_pressed():
	console_controller.show_blueprint()
	pass # Replace with function body.


func _on_button_pressed():
	console_controller.show_test()
