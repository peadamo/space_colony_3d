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

var speed=20
var is_on_use=false

var is_lunching=false
func start_lunch():
	print("pod starting _lunch")
	is_lunching=true
	
var is_back_to_hangar = false
func back_to_hangar():
	print("back to hangar")
	is_back_to_hangar=true
	is_on_use=false

var blue_print_on=false
func _unhandled_input(event):
	if is_on_use:
		
		if event is InputEventMouseMotion:
			pod_y.rotate_y(-event.relative.x*mouse_sensitivity)
			pod_x.rotate_x(-event.relative.y*mouse_sensitivity)
		
		if blue_print_on:
			if event is InputEventMouseButton:
				#click izquierdo
				if event.button_index==1 and event.pressed:
						print(new_ship_node_blueprint.global_position)
						new_ship_node_blueprint.global_position=round(new_ship_node_blueprint.global_position*10)/10
						print(new_ship_node_blueprint.global_position)
						
						new_ship_node_blueprint.reparent(ship.hull)
						new_ship_node_blueprint.enable_collision_all_faces()
						ship.add_new_ship_node_faces(new_ship_node_blueprint)
						create_new_blueprint_model(actual_node_model)
						
				#click derecho
				if event.button_index==2 and event.pressed:
					blue_print_on=false
					$pointer_mesh_ref.visible=false
				#rueda arriba
				if event.button_index==4 and event.pressed:
					print("rueda arriba")
					change_actual_node_model(1)
					update_blueprint_model()
				#rueda abajo
				if event.button_index==5 and event.pressed:
					print("rueda abajo")
					change_actual_node_model(-1)
					update_blueprint_model()
					
			if Input.is_action_just_pressed("rotate_left"):
				print("rotate_left")
				new_ship_node_blueprint.rotate_y(deg_to_rad(-90))
			if Input.is_action_just_pressed("rotate_rigth"):
				print("rotate_rigth")
				
				new_ship_node_blueprint.rotate_y(deg_to_rad(90))

		if Input.is_action_just_pressed("add_hull_block"):
			blue_print_on=!blue_print_on
			if blue_print_on:
				update_blueprint_model()
				$pointer_mesh_ref.visible=true
				
			else:
				
				$pointer_mesh_ref.visible=false


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
	if blue_print_on:
		check_raycast()
	
@onready var ray_cast_3d :RayCast3D = $pod_y/pod_x/RayCast3D
var object_in_view
var object_to_build
@onready var label_3d = $pod_y/pod_x/screens/Label3D
@onready var pointer_mesh_ref = $pointer_mesh_ref


var new_ship_node_blueprint : Node3D= null

func check_raycast():
	object_in_view = ray_cast_3d.get_collider()
	if object_in_view != null :
		if object_in_view.is_in_group("ship_node_face"):
			pointer_mesh_ref.global_position=object_in_view.get_new_shipNode_position()

#region Construction hull
var actual_node_model = "CUBE"
func update_blueprint_model():
	CUSTOM.clear_node_children(pointer_mesh_ref)
	create_new_blueprint_model(actual_node_model)

const SHIP_NODE_CUBE_3X_3 = preload("res://ship/ship_parts/ship_node_cube_3x3.tscn")
const SHIP_NODE_PRISM_3X_3 = preload("res://ship/ship_parts/ship_node_prism_3x3.tscn")
const SHIP_NODE_PRISM_3X_6 = preload("res://ship/ship_parts/ship_node_prism_3x6.tscn")	

func create_new_blueprint_model(model):
		match model:
			"CUBE":
				pointer_mesh_ref.add_child(SHIP_NODE_CUBE_3X_3.instantiate())
			"PRISM_3X3":
				pointer_mesh_ref.add_child(SHIP_NODE_PRISM_3X_3.instantiate())
			"PRISM_3X6":
				pointer_mesh_ref.add_child(SHIP_NODE_PRISM_3X_6.instantiate())
		new_ship_node_blueprint=pointer_mesh_ref.get_child(-1)

var node_models : Array = ["CUBE","PRISM_3X3","PRISM_3X6"]

func change_actual_node_model(val):
	var actual_index = node_models.find(actual_node_model)
	var new_index = actual_index + val
	if new_index > node_models.size()-1:
		new_index = 0
	actual_node_model = node_models[new_index]
#endregion
	
