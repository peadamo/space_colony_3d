extends Node
@export var base_ship : Node3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	$debug_data/fps.text = str(Performance.get_monitor(Performance.TIME_FPS))
	
