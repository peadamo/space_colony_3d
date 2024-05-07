extends Node
@export var player : CharacterBody3D
@export var pointer_marker : Marker3D
@onready var player_build_menu = $"../../Control/player_build_menu"
@onready var ray_cast_3d : RayCast3D = $"../../head/head_camera/RayCast3D"

var is_active = false
var is_blueprint_active = false
# click counter es una truchada para que no me duplique el click el click en el primer menu aca
var click_counter = 0

func _unhandled_input(event):
	if is_active:
		if is_blueprint_active:
			
			if event is InputEventMouseButton:
				if event.button_index == 1 and event.pressed:
					if click_counter>=1:
						player.ship.add_new_building(curret_build_blueprint,pointer_marker.global_position,exp_rot)
					click_counter+=1
				
			if Input.is_action_just_pressed("rotate_left"):
					rotate_blueprint(-1)
			if Input.is_action_just_pressed("rotate_rigth"):
					rotate_blueprint(-1)

func turn_on():
	print("construction_mode ON")
	is_active = true
	player_build_menu.show_build_menu()
	$"../../head/head_camera/player_arms2".grab_gun()
	
func turn_off():
	print("construction_mode OFF")
	is_active = false
	player_build_menu.hide_build_menu()
	cancel_blueprint_display()
	$"../../head/head_camera/player_arms2".store_gun()


@onready var pointer_marker_pos_updater :Timer = $pointer_marker_pos_updater

var curret_build_blueprint = null
func load_blueprint(blueprint:PackedScene):
	curret_build_blueprint=blueprint
	CUSTOM.clear_node_children(pointer_marker)
	pointer_marker.add_child(blueprint.instantiate())
	pointer_marker_pos_updater.start()
	ray_cast_3d.set_collision_mask_value(6,true)
	is_blueprint_active = true
	
var exp_rot = Vector3.ZERO
func _on_pointer_marker_pos_updater_timeout():
	var construction_spot = ray_cast_3d.get_collider()
	if construction_spot != null :
		pointer_marker.global_position = round(update_pointer_pos()*10)/10
		pointer_marker.rotation = construction_spot.spot_marker.global_rotation
		pointer_marker.get_child(-1).rotation.y=rot_modifier
		exp_rot = (pointer_marker.get_child(-1).global_rotation)
func cancel_blueprint_display():
	CUSTOM.clear_node_children(pointer_marker)
	pointer_marker_pos_updater.stop()
	ray_cast_3d.set_collision_mask_value(6,false)
	is_blueprint_active = false
	click_counter = 0
	
	
	
	
	
	
	
var rot_modifier = 0
func rotate_blueprint(val):
	rot_modifier+=deg_to_rad(90*val)

func update_pointer_pos():
	var spaceState=player.get_world_3d().direct_space_state
	var mousePos = Vector2(1366,768)/2
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) *2000
	var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd,0xA)
	var rayArray = spaceState.intersect_ray(Parameters)
	#print(rayArray.position)
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3.ZERO





#func _unhandled_input(event):
	#
	#if player.construction_mode_on:
		#
		#if Input.is_action_just_pressed("use_object"):
			#if player.looking_at_prebuild_object:
				#player.interactive_object_in_view.build()
				#player.looking_at_prebuild_object=false
			#if player.looking_at_internalWall:
				#player.interactive_object_in_view.build_wall()
				#
		#if Input.is_action_just_pressed("delete_objeect"):
			#if player.looking_at_building:
				#player.interactive_object_in_view.destroy_building()
#
				#
		#if is_showing_blue_print_to_build:
			#
			#if player.can_put_blueprint :
				#
				#if Input.is_action_just_pressed("left_click"):
					#is_showing_blue_print_to_build=false
					#var blueprint_node=player.pointer_marker.get_child(-1)
					#blueprint_node.blue_print_controller.blueprint_placed()
					#
					#blueprint_node.reparent(player.ship.ship_buildings)
					#load_blueprint(actual_blueprint,player.is_floor_blue_print)
				#if Input.is_action_just_pressed("rigth_click"):
					#is_showing_blue_print_to_build=false
					#
					#
					#CUSTOM.clear_node_children(player.pointer_marker)
					#player.can_show_radial_menu=true
			#
				#if Input.is_action_just_pressed("rotate_left"):
					#player.pointer_marker.rotate(Vector3(0,1,0),deg_to_rad(-90))
					#pass
				#if Input.is_action_just_pressed("rotate_rigth"):
					#player.pointer_marker.rotate(Vector3(0,1,0),deg_to_rad(+90))
					#pass
			#
#
#
#
#
#
#
#
#var is_showing_blue_print_to_build=false
#const BASIC_WALL = preload("res://assets/3d_models/ship/basic_wall/basic_wall.tscn")	
#const POD_HANGAR = preload("res://assets/3d_models/ship/pod_hangar/pod_hangar.tscn")
#const OXIGEN_GENERATOR = preload("res://assets/3d_models/ship/oxigen_generator/oxigen_generator.tscn")
#var actual_blueprint=null
#
#func load_blueprint(blue_print,is_on_floor):
	#player.is_floor_blue_print=is_on_floor
	#actual_blueprint=blue_print
	#CUSTOM.clear_node_children(player.pointer_marker)
	#print("loaded blue_print")
	#var blue_print_model=null
	#match blue_print:
		#"Pod Hangar":
			#blue_print_model=POD_HANGAR
		#"basic_wall":
			#blue_print_model=BASIC_WALL
		#"Oxygen Generator":
			#blue_print_model=OXIGEN_GENERATOR
	#if blue_print_model != null:
		#player.pointer_marker.add_child(blue_print_model.instantiate())
		#is_showing_blue_print_to_build=true
		#player.can_show_radial_menu=false



