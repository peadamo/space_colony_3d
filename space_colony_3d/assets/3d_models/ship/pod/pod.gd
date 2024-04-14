extends CharacterBody3D
var mouse_sensitivity=0.002
@onready var pod_y = $pod_y
@onready var pod_x = $pod_y/pod_x
var speed=10

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pod_y.rotate_y(-event.relative.x*mouse_sensitivity)
		pod_x.rotate_x(-event.relative.y*mouse_sensitivity)
		print(pod_x.rotation_degrees)
		


func _physics_process(delta):
	var input_dir=Input.get_vector("move_left","move_rigth","move_foward","move_backward")	
	var direction = (pod_y.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity.y = pod_y.rotation.y * speed
		
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		velocity.y = 0.0
		
		
		

		
		
		
		
		
	move_and_slide()
	
	
	
	
