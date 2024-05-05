extends Node
@export var player : CharacterBody3D
@onready var radial_menu = $"../../Control/RadialMenu"
@onready var build_menu = $"../../Control/Build_menu"


func _ready():
	radial_menu.visible=false
	build_menu.visible=false

func _unhandled_input(event):
	if !player.is_in_pod:
		if Input.is_action_just_pressed("show_radial_menu") and player.can_show_radial_menu:
			player.can_put_blueprint=false
			player.can_move_head=false
			radial_menu.visible=true
			radial_menu.is_radial_menu_on=true
			radial_menu.load_menu("start_menu")
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			
		if Input.is_action_just_released("show_radial_menu"):
			player.can_put_blueprint=true
			player.can_move_head=true
			radial_menu.is_radial_menu_on=false
			radial_menu.visible=false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
