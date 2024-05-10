extends Node
@export var player : CharacterBody3D
@export var pointer_marker : Marker3D
@onready var ray_cast_3d : RayCast3D = $"../../../head/head_camera/RayCast3D"
@export var int_wall_timer : Timer

var is_active = false
const METAL_PLATE_WALL = preload("res://ship/ship_walls/metal_plate_wall.tscn")


func _unhandled_input(event):
	if is_active:
		if event is InputEventMouseButton:
			if event.button_index == 1 and event.pressed:
					print("internal_wall_construction_click")
					place_blueprint()

func turn_on():
	print("internal_walls_construction ON")
	is_active = true
	player.player_arms_2.grab_book()
	ray_cast_3d.set_collision_mask_value(5,true)
	$intWall_timer.start()
	load_blueprint(METAL_PLATE_WALL)
	
func turn_off():
	print("internal_walls_construction OFF")
	is_active = false
	player.player_arms_2.store_book()
	ray_cast_3d.set_collision_mask_value(5,false)
	int_wall_timer.stop()
	CUSTOM.clear_node_children(pointer_marker)
	

var wall_position_marker=null
var last_object_in_view=null
var object_in_view 
func _on_int_wall_timer_timeout():
	object_in_view =ray_cast_3d.get_collider()
	if object_in_view != null:
		last_object_in_view=object_in_view
		if wall_position_marker != object_in_view.wall_position_marker:
			wall_position_marker=object_in_view.wall_position_marker
		
	blueprint_display_manager()
		
		
func blueprint_display_manager():
	if wall_position_marker != null:
		pointer_marker.global_position=wall_position_marker.global_position
		pointer_marker.global_rotation=wall_position_marker.global_rotation
		
		
		
var current_blueprint = null

func load_blueprint(blueprint:PackedScene):
	CUSTOM.clear_node_children(pointer_marker)
	pointer_marker.rotation = Vector3.ZERO
	pointer_marker.rotation.x = deg_to_rad(90)
	pointer_marker.add_child(blueprint.instantiate())
	current_blueprint=pointer_marker.get_child(-1)

func place_blueprint():
	if last_object_in_view != null :
		print(last_object_in_view)
		last_object_in_view.add_construction(METAL_PLATE_WALL)

