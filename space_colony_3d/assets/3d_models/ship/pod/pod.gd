extends CharacterBody3D
var mouse_sensitivity=0.002
@onready var pod_y = $pod_y
@onready var pod_x = $pod_y/pod_x
@onready var pod = $"."
var speed=10
var is_on_use=false
@onready var player_holder = $pod_y/pod_x/player_holder
func start():
	is_on_use=true

func _unhandled_input(event):
	if is_on_use:
		if event is InputEventMouseMotion:
			pod_y.rotate_y(-event.relative.x*mouse_sensitivity)
			pod_x.rotate_x(-event.relative.y*mouse_sensitivity)
		
		if Input.is_action_pressed("x_ray_vision"):
			ship.active_xView_vision()
		
@onready var giroscope_start = $pod_y/pod_x/giroscope_start
@onready var giroscope_front = $pod_y/pod_x/giroscope_start/giroscope_front
@onready var giroscope_up = $pod_y/pod_x/giroscope_start/giroscope_up
@onready var giroscope_down = $pod_y/pod_x/giroscope_start/giroscope_down
@onready var giroscope_back = $pod_y/pod_x/giroscope_start/giroscope_back
@onready var giroscope_left = $pod_y/pod_x/giroscope_start/giroscope_left
@onready var giroscope_rigth = $pod_y/pod_x/giroscope_start/giroscope_rigth

@onready var ship = get_tree().current_scene.base_ship



func _physics_process(delta):
	if is_on_use:
	
		var start_pos=giroscope_start.global_position
		var pod_orintation=Vector3.ZERO
		
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
			
		var speed_multi=1
		if Input.is_action_pressed("sprint"):
			speed_multi=3
			
		velocity=pod_orintation*delta*speed*10*speed_multi
			
			
		move_and_slide()
		
	
