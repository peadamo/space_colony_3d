extends Node3D
var mouse_sensitivity=0.002
var speed=10
@onready var head:Node3D = $head
@onready var head_camera:Camera3D = $head/head_camera
var can_rotate_camera=false
var control_on=true

func _input(event):
	if can_rotate_camera:
		if event is InputEventMouseMotion:
			$head.rotate_y(-event.relative.x*mouse_sensitivity)
			$head/head_camera.rotate_x(-event.relative.y*mouse_sensitivity)
		
	if event is InputEventMouseButton:
		if event.button_index==3:
			if event.pressed:
				can_rotate_camera=true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				
			else :
				can_rotate_camera=false
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		if event.button_index==4 and event.pressed:
			head.position.y -= 0.1
		if event.button_index==5 and event.pressed:
			head.position.y += 0.1


		
func _process(delta):
	if control_on:
		var input_dir=Input.get_vector("move_left","move_rigth","move_foward","move_backward")	
		var direction = ($head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			head.position.x += direction.x * speed * delta
			head.position.z += direction.z * speed * delta


func set_control_on():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	head_camera.current=true
	control_on=true
	
func set_control_off():
	head_camera.current=false
	control_on=false
