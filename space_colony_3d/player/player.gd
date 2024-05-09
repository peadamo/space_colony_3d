extends CharacterBody3D
@export var ship : Node3D

#player_scripts
@onready var construction = $scripts/construction
@onready var movement = $scripts/movement
@onready var interactions = $scripts/interactions
@onready var gui = $scripts/gui


# Node params, states and modifiers
@onready var player = $"."
@onready var head_camera = $head/head_camera
@onready var collision_shape_3d = $CollisionShape3D

#Player stats
var gravity=9.8
var jump_velocity=5
var speed=5




var can_move=true
var can_move_head=true
var can_move_head_default=true
var is_in_pod=false
var can_put_blueprint=false
var can_show_radial_menu=true
var is_gun_on_hand = false
var is_walking=false

# Interaction values
var interactive_object_in_view
var looking_at_interactive_object=false
var looking_at_prebuild_object=false
var looking_at_building=false
var looking_at_hangar=false
var looking_at_internalWall = false
var is_floor_blue_print=true

#Params modifiers
func get_into_pod():
	can_move=false
	can_move_head=false
	can_move_head_default=false
	is_in_pod=true
	collision_shape_3d.disabled=true
	position=Vector3.ZERO
	rotation=Vector3.ZERO
	$head.rotation=Vector3.ZERO
	$head/head_camera.rotation=Vector3.ZERO
	
func leave_pod(pos):
	can_move=true
	can_move_head=true
	can_move_head_default=true
	is_in_pod=false
	collision_shape_3d.disabled=false
	global_position=pos
	rotation=Vector3.ZERO


#Player conditional values
var construction_mode_on = false

func _unhandled_input(_event):

	if Input.is_action_just_pressed("construction_mode"):
		change_construction_mode_state()

func change_construction_mode_state():
	construction_mode_on = !construction_mode_on
	if construction_mode_on:
		construction.turn_on()
	else: 
		construction.turn_off()
