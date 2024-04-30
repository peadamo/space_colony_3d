extends Node3D
@onready var animation_player : AnimationPlayer = $AnimationPlayer


func grab_gun():
	animation_player.play("grab_gun")
	
func store_gun():
	animation_player.play_backwards("grab_gun")
