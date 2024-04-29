extends CharacterBody3D
var mouse_sensitivity=0.002
@onready var pod_y = $pod_y
@onready var pod_x = $pod_y/pod_x
@onready var pod = $"."
@onready var ship = get_tree().current_scene.base_ship
@onready var pod_hangar = $"../../.."
@onready var giroscope_start = $pod_y/pod_x/giroscope_start
@onready var giroscope_front = $pod_y/pod_x/giroscope_start/giroscope_front
@onready var giroscope_up = $pod_y/pod_x/giroscope_start/giroscope_up
@onready var giroscope_down = $pod_y/pod_x/giroscope_start/giroscope_down
@onready var giroscope_back = $pod_y/pod_x/giroscope_start/giroscope_back
@onready var giroscope_left = $pod_y/pod_x/giroscope_start/giroscope_left
@onready var giroscope_rigth = $pod_y/pod_x/giroscope_start/giroscope_rigth
@export var hangar_marker : Marker3D
@export var hangar_landed_marker : Marker3D
@onready var player_holder = $pod_y/pod_x/player_holder

var speed=10
var is_on_use=false

func start():
	#is_on_use=true
	pass
	
	
var is_lunching=false
func start_lunch():
	print("pod starting _lunch")
	is_lunching=true
	
var is_back_to_hangar = false
func back_to_hangar():
	print("back to hangar")
	is_back_to_hangar=true
	is_on_use=false

var x_ray_on=false
var blue_print_on=false
var build_hull_block_on=false
const HULL_3X_3_BLUEPRINT = preload("res://assets/3d_models/ship/hull_modules/HULL 3x3 blueprint.tscn")
func _unhandled_input(event):
	
	if is_on_use:
		if event is InputEventMouseMotion:
			pod_y.rotate_y(-event.relative.x*mouse_sensitivity)
			pod_x.rotate_x(-event.relative.y*mouse_sensitivity)
		
		if event is InputEventMouseButton:
			
			if event.button_index==1 and event.pressed:
				if blue_print_on:
					ship.add_hull_wall_blueprint(pointer_mesh_ref.global_position)
					
				if build_hull_block_on and object_to_build != null:
					object_to_build.get_parent().build_blueprint()
					
			if event.button_index==2 and event.pressed:
				if blue_print_on:
					blue_print_on=false
					$pointer_mesh_ref/Hull3x3Blueprint.visible=false
				
		if Input.is_action_just_pressed("x_ray_vision"):
			x_ray_on=!x_ray_on
			if x_ray_on:
				ship.active_xView_vision()
			else:
				ship.inactive_xView_vision()
				
		if Input.is_action_just_pressed("add_hull_block"):
			blue_print_on=!blue_print_on
			if blue_print_on:
				$pointer_mesh_ref/Hull3x3Blueprint.visible=true
				
			else:
				$pointer_mesh_ref/Hull3x3Blueprint.visible=false
				
		if Input.is_action_just_pressed("build_hull_block"):
			build_hull_block_on=!build_hull_block_on
			
			if build_hull_block_on:
				ray_cast_3d.set_collision_mask(16)

			else:
				ray_cast_3d.set_collision_mask(8)

func _physics_process(delta):
	velocity=Vector3.ZERO
	var pod_orintation=Vector3.ZERO
	var start_pos=giroscope_start.global_position
	if is_back_to_hangar:
		var hangar_pos= hangar_marker.global_position
		var pod_pos = $".".global_position
		var distance = pod_pos.distance_to(hangar_pos)
		print("going to hangar, DISTANCE:",distance)
		
		if distance > 0.1:
			var direction=pod_pos.direction_to(hangar_pos)
			print("is to far, DIRECTION:",direction)
			velocity=direction
			look_at(Vector3(hangar_pos.x,pod_pos.y,hangar_pos.z))
			
		else:
			is_back_to_hangar=false
			rotation=Vector3.ZERO
			pod_y.rotation=Vector3.ZERO
			pod_x.rotation=Vector3.ZERO
			
			
			position=Vector3.ZERO
			pod_hangar.player_exit_pod()
	if is_lunching:
		if $".".position.y > -3:
			pod_orintation+=start_pos.direction_to(giroscope_down.global_position)
			velocity=pod_orintation*delta*speed*10
		else :
			is_lunching=false
			is_on_use=true
	if is_on_use:
		
		if Input.is_action_pressed("move_foward"):
			pod_orintation+=start_pos.direction_to(giroscope_front.global_position)
		if Input.is_action_pressed("move_backward"):
			pod_orintation+=start_pos.direction_to(giroscope_back.global_position)
		if Input.is_action_pressed("move_left"):
			pod_orintation+=start_pos.direction_to(giroscope_left.global_position)
		if Input.is_action_pressed("move_rigth"):
			pod_orintation+=start_pos.direction_to(giroscope_rigth.global_position)
		if Input.is_action_pressed("move_up"):
			pod_orintation+=start_pos.direction_to(giroscope_up.global_position)
		if Input.is_action_pressed("move_down"):
			pod_orintation+=start_pos.direction_to(giroscope_down.global_position)
			
		#if Input.is_action_pressed("rotate_left"):
			#pod_x.rotate_z(deg_to_rad(1))
			#
		#if Input.is_action_pressed("rotate_rigth"):
			#pod_x.rotate_z(deg_to_rad(-1))
		
		velocity=pod_orintation*delta*speed*10
	
	move_and_slide()
	check_raycast()
	
@onready var ray_cast_3d :RayCast3D = $pod_y/pod_x/RayCast3D
var object_in_view
var object_to_build
@onready var label_3d = $pod_y/pod_x/screens/Label3D
@onready var pointer_mesh_ref = $pointer_mesh_ref

func check_raycast():
	object_in_view = ray_cast_3d.get_collider()
	
	if object_in_view != null :
		label_3d.text = str("")
		if object_in_view.is_in_group("hull_block"):
			#label_3d.text = str(object_in_view.get_blueprint_position())
			pointer_mesh_ref.global_position=object_in_view.get_blueprint_position()
		if  object_in_view.is_in_group("blue_print"):
			object_to_build=object_in_view
			label_3d.text = str("build:",object_in_view)
			
			pass
