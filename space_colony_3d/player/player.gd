extends CharacterBody3D
var mouse_sensitivity=0.002
var gravity=9.8
var jump_velocity=5
var speed=10
var control_on=true
@onready var head_camera:Camera3D = $head/head_camera
@export var ship : Node3D
var can_move=true
var can_move_head=true
var can_move_head_default=true
@onready var radial_menu = $Control/RadialMenu

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	radial_menu.visible=false

var can_put_blueprint=false
var can_show_radial_menu=true
func _unhandled_input(event):
	if can_move_head:
		if event is InputEventMouseMotion:
			$head.rotate_y(-event.relative.x*mouse_sensitivity)
			$head/head_camera.rotate_x(-event.relative.y*mouse_sensitivity)
			$head/head_camera.rotation.x=clamp($head/head_camera.rotation.x,deg_to_rad(-89.9),1)
	
	if can_move_head_default == false:
		if Input.is_action_just_pressed("move_head"):
			can_move_head=true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		if Input.is_action_just_released("move_head"):
			can_move_head=false
			Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
			
		if Input.is_action_just_pressed("use_object"):
			can_move_head_default = true
			can_move_head=true
			can_move=true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
			
	if Input.is_action_just_pressed("use_object"):
		
		if looking_at_interactive_object:
			interactive_object_in_view.use_object($".")

			
	if is_showing_blue_print_to_build:
		
		if can_put_blueprint :
			
			if Input.is_action_just_pressed("left_click"):
				is_showing_blue_print_to_build=false
				
				print("construyo el blueprint")
				
				var blueprint_node=pointer_mesh_ref.get_child(-1)
				blueprint_node.reparent(ship.ship_buildings)
				CUSTOM.clear_node_children(pointer_mesh_ref)
				can_show_radial_menu=true
				
			if Input.is_action_just_pressed("rigth_click"):
				is_showing_blue_print_to_build=false
				
				print("borro el blueprint")
				
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
		
	#if Input.is_action_just_pressed("left_click"):
		#if is_showing_blue_print_to_build:
			#var blueprint_node=pointer_mesh_ref.get_child(-1)
			#blueprint_node.reparent(ship.ship_buildings)
			

func _physics_process(delta):
	if !is_on_floor():
		velocity.y-=gravity*delta
		
	if control_on:
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y=jump_velocity
			
			
		var input_dir=Input.get_vector("move_left","move_rigth","move_foward","move_backward")	
		var direction = ($head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = 0.0
			velocity.z = 0.0
	if can_move:
		move_and_slide()
	
	
	
	raycast_process()
	
@onready var ray_cast_3d : RayCast3D = $head/head_camera/RayCast3D

var interactive_object_in_view
var looking_at_interactive_object=false

func raycast_process():
	var raycastCollide=ray_cast_3d.get_collider()
	if raycastCollide != null:
		if raycastCollide.is_in_group("interactive_object"):
			interactive_object_in_view=raycastCollide.get_parent().get_parent()
			$Control/Label.visible=true
			looking_at_interactive_object=true
		else :
			looking_at_interactive_object=false
			$Control/Label.visible=false
			
	

func set_control_on():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head_camera.current=true
	control_on=true
	
func set_control_off():
	control_on=false
	head_camera.current=false
	
@onready var pointer_mesh_ref = $pointer_mesh_ref
	
func calc_pointer_ref_position():
	var new_position=update_pointer_pos()
	var value_x_sign=1
	if new_position.x<0:
		value_x_sign=-1
	var value_x_module=new_position.x*value_x_sign
	var value_x=(floor(value_x_module)+0.5)*value_x_sign
	
	var value_z_sign=1
	if new_position.z<0:
		value_z_sign=-1
	var value_z_module=new_position.z*value_z_sign
	var value_z=(floor(value_z_module)+0.5)*value_z_sign
	
	var value_y_sign=1
	if new_position.y<0:
		value_y_sign=-1
	var value_y_module=new_position.y*value_y_sign
	var value_y=(floor(value_y_module)+0.5)*value_y_sign
	
	var cal_corrected_position = Vector3(value_x,0,value_z)
	
	
	if cal_corrected_position != corrected_position:
		corrected_position=cal_corrected_position
		update_mesh_ref_position()
		
	#if new_position != corrected_position:
		#corrected_position=new_position
		#update_mesh_ref_position()
		
var corrected_position
func update_mesh_ref_position():
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
	calc_pointer_ref_position()
	

var is_showing_blue_print_to_build=false
	
func load_blueprint(blue_print):
	print("loaded blue_print")
	var blue_print_model=null
	match blue_print:
		"Pod Hangar":
			blue_print_model=load("res://assets/3d_models/ship/pod_hangar/pod_hangar.tscn")
			
	if blue_print_model != null:
		pointer_mesh_ref.add_child(blue_print_model.instantiate())
		is_showing_blue_print_to_build=true
		can_show_radial_menu=false
		
