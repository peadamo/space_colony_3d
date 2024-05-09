extends Node
@export var player : CharacterBody3D
@onready var ray_cast_3d = $"../../../head/head_camera/RayCast3D"

var is_active = false

func turn_on():
	print("internal_walls_construction ON")
	is_active = true
	player.player_arms_2.grab_book()
func turn_off():
	print("internal_walls_construction OFF")
	is_active = false
	player.player_arms_2.store_book()
