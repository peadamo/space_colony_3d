extends Node3D

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("IDLE")
	pass # Replace with function body.


func grab_gun():
	animation_player.play("grab_gun")
	
func store_gun():
	animation_player.play_backwards("grab_gun")
	
