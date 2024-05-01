extends CharacterBody3D
var mouse_sensitivity=0.002
var gravity=9.8
var jump_velocity=5
var speed=5
@onready var player = $"."

@onready var head_camera = $head/head_camera

@export var ship : Node3D

var can_move=true
var can_move_head=true
var can_move_head_default=true
var is_in_pod=false
@onready var collision_shape_3d = $CollisionShape3D

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
	#$head.rotation=Vector3.ZERO
	#$head/head_camera.rotation=Vector3.ZERO

@onready var radial_menu = $Control/RadialMenu
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	radial_menu.visible=false
var can_put_blueprint=false
var can_show_radial_menu=true
var is_gun_on_hand = false
func _unhandled_input(event):
	
	if can_move_head:
		if event is InputEventMouseMotion:
			$head.rotate_y(-event.relative.x*mouse_sensitivity)
			$head/head_camera.rotate_x(-event.relative.y*mouse_sensitivity)
			$head/head_camera.rotation.x=clamp($head/head_camera.rotation.x,deg_to_rad(-89.9),1)
			calc_pointer_ref_position()
	
	if can_move_head_default == false:
		
		if Input.is_action_just_pressed("move_head"):
			can_move_head=true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		if Input.is_action_just_released("move_head"):
			
			rotation=Vector3.ZERO
			$head.rotation=Vector3.ZERO
			$head/head_camera.rotation=Vector3.ZERO
			
			can_move_head=false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		#if Input.is_action_just_pressed("use_object"):
			#can_move_head_default = true
			#can_move_head=true
			#can_move=true
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			
			
	if Input.is_action_just_pressed("use_object"):
		if looking_at_prebuild_object:
			print("builddd")
			interactive_object_in_view.build()
			looking_at_prebuild_object=false
			
	if is_in_pod:
		if Input.is_action_just_pressed("use_object"):
			if looking_at_interactive_object:
				interactive_object_in_view.use_object()
				print("player use interactive object")
		
		pass
		
	else:
		
		if Input.is_action_just_pressed("use_object"):
			
			if looking_at_interactive_object:
				interactive_object_in_view.use_object($".")
				print("player use interactive object")

				
			if looking_at_hangar:
				interactive_object_in_view.enter_pod($".")
				
		if Input.is_action_just_pressed("delete_objeect"):
			if looking_at_building:
				interactive_object_in_view.destroy_building()
				
		if is_showing_blue_print_to_build:
			
			if can_put_blueprint :
				
				if Input.is_action_just_pressed("left_click"):
					is_showing_blue_print_to_build=false
					var blueprint_node=pointer_mesh_ref.get_child(-1)
					blueprint_node.blue_print_controller.blueprint_placed()
					
					blueprint_node.reparent(ship.ship_buildings)
					load_blueprint(actual_blueprint,is_floor_blue_print)
				if Input.is_action_just_pressed("rigth_click"):
					is_showing_blue_print_to_build=false
					
					
					CUSTOM.clear_node_children(pointer_mesh_ref)
					can_show_radial_menu=true
			
				if Input.is_action_just_pressed("rotate_left"):
					pointer_mesh_ref.rotate(Vector3(0,1,0),deg_to_rad(-90))
					pass
				if Input.is_action_just_pressed("rotate_rigth"):
					pointer_mesh_ref.rotate(Vector3(0,1,0),deg_to_rad(+90))
					pass
			
		if Input.is_action_just_pressed("show_radial_menu") and can_show_radial_menu:
			can_put_blueprint=false
			can_move_head=false
			radial_menu.visible=true
			radial_menu.is_radial_menu_on=true
			radial_menu.load_menu("start_menu")
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			
		if Input.is_action_just_released("show_radial_menu"):
			can_put_blueprint=true
			can_move_head=true
			radial_menu.is_radial_menu_on=false
			radial_menu.visible=false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		if Input.is_action_just_pressed("grab_gun"):
			is_gun_on_hand=!is_gun_on_hand
			if is_gun_on_hand :
				$head/head_camera/player_arms2.grab_gun()
			else:
				$head/head_camera/player_arms2.store_gun()
				
		if Input.is_action_just_pressed("carry"):
			is_gun_on_hand=!is_gun_on_hand
			if is_gun_on_hand :
				$head/head_camera/player_arms2.grab_book()
			else:
				$head/head_camera/player_arms2.store_book()

var is_walking=false

func _physics_process(delta):
	if is_in_pod == false:
		if !is_on_floor():
			velocity.y-=gravity*delta
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y=jump_velocity
			
		var input_dir=Input.get_vector("move_left","move_rigth","move_foward","move_backward")	
		var direction = ($head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
			calc_pointer_ref_position()
			if is_walking == false :
				is_walking = true
				$head/player_torso.get_walk()
		else:
			velocity.x = 0.0
			velocity.z = 0.0
			if is_walking == true :
				is_walking = false
				$head/player_torso.get_idle()
			
		move_and_slide()
	
@onready var ray_cast_3d : RayCast3D = $head/head_camera/RayCast3D

var interactive_object_in_view
var looking_at_interactive_object=false
var looking_at_prebuild_object=false
var looking_at_building=false
var looking_at_hangar=false


func raycast_process():
	var raycastCollide=ray_cast_3d.get_collider()
	if raycastCollide != null:
		$Control/debug.text = str(raycastCollide)
		
		if raycastCollide.is_in_group("interactive_object"):
			interactive_object_in_view=raycastCollide
			$Control/Label.visible=true
			$Control/Label.text="Use"
			looking_at_interactive_object=true
		elif raycastCollide.is_in_group("blue_print"):
			$Control/Label.visible=true
			$Control/Label.text="Build"
			looking_at_prebuild_object=true
			interactive_object_in_view=raycastCollide.get_parent()
		elif raycastCollide.is_in_group("building"):
			$Control/Label.visible=true
			$Control/Label.text="x to delete"
			looking_at_building=true
			interactive_object_in_view=raycastCollide.get_parent()
		elif raycastCollide.is_in_group("hangar_door"):
			$Control/Label.visible=true
			$Control/Label.text="E to use pod"
			looking_at_hangar=true
			interactive_object_in_view=raycastCollide
		else :
			looking_at_interactive_object=false
			looking_at_prebuild_object=false
			looking_at_building=false
			looking_at_hangar=false
			$Control/Label.visible=false
			
	

	
@onready var pointer_mesh_ref = $pointer_mesh_ref
	
func calc_pointer_ref_position():
	if is_showing_blue_print_to_build or true:
		var new_position=update_pointer_pos()
		
		var value_x
		var value_x_sign=1
		if new_position.x<0:
			value_x_sign=-1
		var value_x_module=new_position.x*value_x_sign
		var value_x_decimal=value_x_module-floor(value_x_module)
		if value_x_decimal>0.5:
			value_x=(floor(value_x_module)+1)*value_x_sign
		else:
			value_x=(floor(value_x_module))*value_x_sign
		
		var value_z
		var value_z_sign=1
		if new_position.z<0:
			value_z_sign=-1
		var value_z_module=new_position.z*value_z_sign
		var value_z_decimal=value_z_module-floor(value_z_module)
		if value_z_decimal>0.5:
			value_z=(floor(value_z_module)+1)*value_z_sign
		else:
			value_z=(floor(value_z_module))*value_z_sign
			
		var value_y
		var value_y_sign=1
		if new_position.y<0:
			value_y_sign=-1
		var value_y_module=new_position.y*value_y_sign
		var value_y_decimal=value_y_module-floor(value_y_module)
		if value_y_decimal>0.5:
			value_y=(floor(value_y_module)+1)*value_y_sign
		else:
			value_y=(floor(value_y_module))*value_y_sign
			
		if value_y>0:
			value_y-=0.5
		
		var cal_corrected_position = Vector3(value_x,value_y,value_z)
		
		#print("new_position",new_position)
		#print("corrected_position",cal_corrected_position)
		
		
		if cal_corrected_position != corrected_position:
			corrected_position=cal_corrected_position
			update_mesh_ref_position()
			
		#if new_position != corrected_position:
			#corrected_position=new_position
			#update_mesh_ref_position()
		
var corrected_position
var is_floor_blue_print=true
func update_mesh_ref_position():
	if is_floor_blue_print:
		
		pointer_mesh_ref.global_position=Vector3(corrected_position.x,0,corrected_position.z)
		
	else:
		pointer_mesh_ref.global_position=corrected_position
	
func update_pointer_pos():
	var spaceState=get_world_3d().direct_space_state
	var mousePos = Vector2(1152.0/2,648.0/2)
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) *2000
	var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd)
	var rayArray = spaceState.intersect_ray(Parameters)
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3.ZERO


func _on__1_sec_timeout():
	raycast_process()

	

var is_showing_blue_print_to_build=false
const BASIC_WALL = preload("res://assets/3d_models/ship/basic_wall/basic_wall.tscn")	
const POD_HANGAR = preload("res://assets/3d_models/ship/pod_hangar/pod_hangar.tscn")
const OXIGEN_GENERATOR = preload("res://assets/3d_models/ship/oxigen_generator/oxigen_generator.tscn")
var actual_blueprint=null

func load_blueprint(blue_print,is_on_floor):
	is_floor_blue_print=is_on_floor
	actual_blueprint=blue_print
	CUSTOM.clear_node_children(pointer_mesh_ref)
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
		pointer_mesh_ref.add_child(blue_print_model.instantiate())
		is_showing_blue_print_to_build=true
		can_show_radial_menu=false
		
