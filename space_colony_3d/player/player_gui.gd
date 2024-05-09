extends Node
@export var player : CharacterBody3D
@onready var player_build_menu = $"../../Control/player_build_menu"




func _unhandled_input(_event):
	if !player.is_in_pod:
		pass
		#if Input.is_action_just_pressed("show_radial_menu") and player.can_show_radial_menu:
			#player.can_put_blueprint=false
			#player.can_move_head=false
			#radial_menu.visible=true
			#radial_menu.is_radial_menu_on=true
			#radial_menu.load_menu("start_menu")
			#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			#
		#if Input.is_action_just_released("show_radial_menu"):
			#player.can_put_blueprint=true
			#player.can_move_head=true
			#radial_menu.is_radial_menu_on=false
			#radial_menu.visible=false
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
