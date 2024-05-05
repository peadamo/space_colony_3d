extends Node
@export var player : CharacterBody3D
@onready var head = $"../../head"
@onready var head_camera = $"../../head/head_camera"
@onready var player_torso = $"../../head/player_torso"


var mouse_sensitivity=0.002


func _unhandled_input(event):
	if player.can_move_head:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x*mouse_sensitivity)
			head_camera.rotate_x(-event.relative.y*mouse_sensitivity)
			head_camera.rotation.x=clamp(head_camera.rotation.x,deg_to_rad(-89.9),1)
	
	if player.can_move_head_default == false:
		
		if Input.is_action_just_pressed("move_head"):
			player.can_move_head=true
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		if Input.is_action_just_released("move_head"):
			
			player.rotation=Vector3.ZERO
			head.rotation=Vector3.ZERO
			head_camera.rotation=Vector3.ZERO
			
			player.can_move_head=false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _physics_process(delta):
	if player.is_in_pod == false:
		if !player.is_on_floor():
			player.velocity.y-=player.gravity*delta
		if Input.is_action_pressed("jump") and player.is_on_floor():
			player.velocity.y=player.jump_velocity
			
		var input_dir=Input.get_vector("move_left","move_rigth","move_foward","move_backward")	
		var direction = (head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			player.velocity.x = direction.x * player.speed
			player.velocity.z = direction.z * player.speed
			
			if player.is_walking == false :
				player.is_walking = true
				player_torso.get_walk()
		else:
			player.velocity.x = 0.0
			player.velocity.z = 0.0
			if player.is_walking == true :
				player.is_walking = false
				player_torso.get_idle()
			
		player.move_and_slide()
