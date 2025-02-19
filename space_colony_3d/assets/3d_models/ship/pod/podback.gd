extends CharacterBody3D
var mouse_sensitivity=0.002
@onready var pod_y = $pod_y
@onready var pod_x = $pod_y/pod_x
@onready var pod = $"."
@onready var ship = get_tree().current_scene.base_ship
@onready var pod_hangar = $"../../.."

var speed=10
var is_on_use=false
@onready var player_holder = $pod_y/pod_x/player_holder

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
	pass

var x_ray_on=false
var blue_print_on=false

const HULL_BLUEPRINT_WITH_WALL = preload("res://assets/3d_models/ship/hull_blueprint/hull_blueprint_with_wall.tscn")
const _3X_3_HULL_FRAME = preload("res://assets/3d_models/ship/hull_modules/3x3_hull_frame/3x_3_hull_frame.tscn")
const HULL_3X_3_BLUEPRINT = preload("res://assets/3d_models/ship/hull_modules/HULL 3x3 blueprint.tscn")
func _unhandled_input(event):
	
	if is_on_use:
		if event is InputEventMouseMotion:
			pod_y.rotate_y(-event.relative.x*mouse_sensitivity)
			pod_x.rotate_x(-event.relative.y*mouse_sensitivity)
		
		if event is InputEventMouseButton:
			if event.button_index==1 and event.pressed:
				ship.add_hull_wall_blueprint(pointer_mesh_ref.global_position)
				
			#if event.button_index==2 and event.pressed:
				#CUSTOM.clear_node_children(pointer_mesh_ref)
		
		if Input.is_action_pressed("x_ray_vision"):
			x_ray_on=!x_ray_on
			if x_ray_on:
				ship.active_xView_vision()
			else:
				ship.inactive_xView_vision()
				
		if Input.is_action_pressed("add_hull_block"):
			blue_print_on=!blue_print_on
			if blue_print_on:
				pointer_mesh_ref.add_child(HULL_3X_3_BLUEPRINT.instantiate())
				
			else:
				CUSTOM.clear_node_children(pointer_mesh_ref)
				
		if Input.is_action_just_pressed("delete_internal_hull_walls"):
			$pod_y/pod_x/screens/PanelContent/SubViewport/ShipBlueprint.update_tilemap()
			ship.update_hull_walls()

@onready var giroscope_start = $pod_y/pod_x/giroscope_start
@onready var giroscope_front = $pod_y/pod_x/giroscope_start/giroscope_front
@onready var giroscope_up = $pod_y/pod_x/giroscope_start/giroscope_up
@onready var giroscope_down = $pod_y/pod_x/giroscope_start/giroscope_down
@onready var giroscope_back = $pod_y/pod_x/giroscope_start/giroscope_back
@onready var giroscope_left = $pod_y/pod_x/giroscope_start/giroscope_left
@onready var giroscope_rigth = $pod_y/pod_x/giroscope_start/giroscope_rigth



@export var hangar_marker : Marker3D
@export var hangar_landed_marker : Marker3D

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
	calc_pointer_ref_position()
		
		
func update_pointer_pos():
	var spaceState=get_world_3d().direct_space_state
	var mousePos = Vector2(1152.0/2,648.0/2)
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) *2000
	var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd,0x2)
	var rayArray = spaceState.intersect_ray(Parameters)
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3.ZERO
	
func calc_pointer_ref_position():
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
	
	var cal_corrected_position = Vector3( value_x,  value_y,  value_z)
	
	
	if cal_corrected_position != corrected_position:
		corrected_position=cal_corrected_position
		update_mesh_ref_position()
			
var corrected_position
var is_floor_blue_print=true
@onready var pointer_mesh_ref = $pointer_mesh_ref

func update_mesh_ref_position():
	pointer_mesh_ref.global_position=Vector3(corrected_position.x,0,corrected_position.z)
	#ship.shipCells_get_position_index(corrected_position)
	
	
