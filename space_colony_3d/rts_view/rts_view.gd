extends Node3D
var mouse_sensitivity=0.002
var speed=10
@onready var head:Node3D = $head
@onready var head_camera:Camera3D = $head/head_camera
var can_rotate_camera=false
var control_on=true
var camera_position:Vector3=Vector3(0,0,0)
var camera_angle:Vector2=Vector2(0,1.55)
var mouse_position:Vector2
@onready var main = $".."
@onready var base_ship = $"../BaseShip"

func _input(event):
	if control_on:
		if can_rotate_camera:
			if event is InputEventMouseMotion:
				$head.rotate_y(-event.relative.x*mouse_sensitivity)
				$head/head_camera.rotate_x(-event.relative.y*mouse_sensitivity)
				$head/head_camera.rotation.x=clamp($head/head_camera.rotation.x,deg_to_rad(-89.9),deg_to_rad(-1))
				camera_angle.y=head_camera.rotation.x+deg_to_rad(90)
				camera_angle.x=head.rotation.y
				
		else:
			if event is InputEventMouseMotion:
				mouse_position=event.position
				var point_position=update_pointer_pos()
				base_ship.put_door(point_position)
				pointer.global_position=point_position
				
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
			
			var head_global_pos=head.global_position
			camera_position=Vector3(head_global_pos.x,head_global_pos.y,head_global_pos.z)
			
		if Input.is_action_pressed("left_click"):
				base_ship.confirm_build()
				
		if Input.is_action_just_pressed("rotate_left"):
			base_ship.rotate_item(1)
		if Input.is_action_just_pressed("rotate_rigth"):
			base_ship.rotate_item(-1)
			

		
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

@onready var ray_cast_3d:RayCast3D = $head/head_camera/RayCast3D

func _on_raycast_timer_timeout():
	var rayCollision=ray_cast_3d.get_collider()
	if rayCollision != null:
		#print(rayCollision.position)
		pass

@onready var pointer = $pointer
@onready var control = $Control


func update_pointer_pos():
	var spaceState=get_world_3d().direct_space_state
	var mousePos = get_viewport().get_mouse_position()
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) *2000
	var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd,2)
	var rayArray = spaceState.intersect_ray(Parameters)
	if rayArray.has("position"):
		rayArray["position"].y=0
		return rayArray["position"]
	return Vector3.ZERO
	

var selected_item=0
func _on_button_pressed():
	selected_item=0
	base_ship.update_item_to_build(selected_item)


func _on_button_2_pressed():
	selected_item=1
	base_ship.update_item_to_build(selected_item)


func _on_button_3_pressed():
	selected_item=2
	base_ship.update_item_to_build(selected_item)
