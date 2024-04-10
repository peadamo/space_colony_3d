extends CharacterBody3D
var mouse_sensitivity=0.002
var gravity=9.8
var jump_velocity=5
var speed=10
var control_on=false
@onready var head_camera:Camera3D = $head/head_camera

var can_move=true
var can_move_head=true
var can_move_head_default=true

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

func raycast_process():
	var raycastCollide=ray_cast_3d.get_collider()
	if raycastCollide != null:
		if raycastCollide.is_in_group("interactive_object"):
			interactive_object_in_view=raycastCollide.get_parent().get_parent()
			interactive_object_in_view.use_object($".")
			print(interactive_object_in_view)
	

func set_control_on():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head_camera.current=true
	control_on=true
	
func set_control_off():
	control_on=false
	head_camera.current=false
