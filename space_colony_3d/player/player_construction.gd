extends Node
@export var player : CharacterBody3D

func _unhandled_input(event):
	
	if player.construction_mode_on:
		
		if Input.is_action_just_pressed("use_object"):
			if player.looking_at_prebuild_object:
				player.interactive_object_in_view.build()
				player.looking_at_prebuild_object=false
			if player.looking_at_internalWall:
				player.interactive_object_in_view.build_wall()
				
		if Input.is_action_just_pressed("delete_objeect"):
			if player.looking_at_building:
				player.interactive_object_in_view.destroy_building()

				
		if is_showing_blue_print_to_build:
			
			if player.can_put_blueprint :
				
				if Input.is_action_just_pressed("left_click"):
					is_showing_blue_print_to_build=false
					var blueprint_node=player.pointer_marker.get_child(-1)
					blueprint_node.blue_print_controller.blueprint_placed()
					
					blueprint_node.reparent(player.ship.ship_buildings)
					load_blueprint(actual_blueprint,player.is_floor_blue_print)
				if Input.is_action_just_pressed("rigth_click"):
					is_showing_blue_print_to_build=false
					
					
					CUSTOM.clear_node_children(player.pointer_marker)
					player.can_show_radial_menu=true
			
				if Input.is_action_just_pressed("rotate_left"):
					player.pointer_marker.rotate(Vector3(0,1,0),deg_to_rad(-90))
					pass
				if Input.is_action_just_pressed("rotate_rigth"):
					player.pointer_marker.rotate(Vector3(0,1,0),deg_to_rad(+90))
					pass
			







var is_showing_blue_print_to_build=false
const BASIC_WALL = preload("res://assets/3d_models/ship/basic_wall/basic_wall.tscn")	
const POD_HANGAR = preload("res://assets/3d_models/ship/pod_hangar/pod_hangar.tscn")
const OXIGEN_GENERATOR = preload("res://assets/3d_models/ship/oxigen_generator/oxigen_generator.tscn")
var actual_blueprint=null

func load_blueprint(blue_print,is_on_floor):
	player.is_floor_blue_print=is_on_floor
	actual_blueprint=blue_print
	CUSTOM.clear_node_children(player.pointer_marker)
	print("loaded blue_print")
	var blue_print_model=null
	match blue_print:
		"Pod Hangar":
			blue_print_model=POD_HANGAR
		"basic_wall":
			blue_print_model=BASIC_WALL
		"Oxygen Generator":
			blue_print_model=OXIGEN_GENERATOR
	if blue_print_model != null:
		player.pointer_marker.add_child(blue_print_model.instantiate())
		is_showing_blue_print_to_build=true
		player.can_show_radial_menu=false
