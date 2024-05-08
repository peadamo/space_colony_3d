extends Node
@export var player : CharacterBody3D
@export var pointer_marker : Marker3D
@onready var player_build_menu = $"../../Control/player_build_menu"
@onready var ray_cast_3d : RayCast3D = $"../../head/head_camera/RayCast3D"

var is_active = false
var is_blueprint_active = false
# click counter es una truchada para que no me duplique el click el click en el primer menu aca
var click_counter = 0
func _unhandled_input(event):
	if is_active:
		if is_blueprint_active:
			
			if event is InputEventMouseButton:
				if event.button_index == 1 and event.pressed:
					if click_counter>=1:
						place_blueprint()
					click_counter+=1
				
			if Input.is_action_just_pressed("rotate_left"):
					rotate_blueprint(-1)
			if Input.is_action_just_pressed("rotate_rigth"):
					rotate_blueprint(+1)
					
		elif already_placed_blueprint_on_view != null:
			if Input.is_action_just_pressed("use_object"):
				player_build_menu.center_label.visible=false
				disable_placed_blueprint_interactions()
				load_blueprint(already_placed_blueprint_on_view.escene_ref)
				already_placed_blueprint_on_view.queue_free()
				click_counter+=1
			if Input.is_action_just_pressed("delete_objeect"):
				already_placed_blueprint_on_view.building_construction_controls.build_it()
				
				
func turn_on():
	print("construction_mode ON")
	is_active = true
	player_build_menu.show_build_menu()
	$"../../head/head_camera/player_arms2".grab_gun()
	enable_placed_blueprint_interactions()
	
func turn_off():
	print("construction_mode OFF")
	is_active = false
	player_build_menu.hide_build_menu()
	cancel_blueprint_display()
	$"../../head/head_camera/player_arms2".store_gun()
	disable_placed_blueprint_interactions()

@onready var pointer_marker_pos_updater :Timer = $pointer_marker_pos_updater

var curret_build_blueprint_path = null
var current_blueprint = null

func load_blueprint(blueprint:PackedScene):
	curret_build_blueprint_path=blueprint
	CUSTOM.clear_node_children(pointer_marker)
	pointer_marker.add_child(blueprint.instantiate())
	ray_cast_3d.set_collision_mask_value(6,true)
	is_blueprint_active = true
	current_blueprint=pointer_marker.get_child(-1)
	pointer_marker_pos_updater.start()
	
var exp_rot = Vector3.ZERO
#una zafada trucha, aveces no toma las variables en el moemnto que creo deberia hacerlo???
var can_be_blueprint_placed = null

func _on_pointer_marker_pos_updater_timeout():
	can_be_blueprint_placed = current_blueprint.can_be_build
	var construction_spot = ray_cast_3d.get_collider()
	if construction_spot != null :
		pointer_marker.global_position = round(update_pointer_pos()*10)/10
		pointer_marker.rotation = construction_spot.spot_marker.global_rotation
		current_blueprint.rotation.y=rot_modifier
		exp_rot = (current_blueprint.global_rotation)
		
func cancel_blueprint_display():
	
	CUSTOM.clear_node_children(pointer_marker)
	pointer_marker_pos_updater.stop()
	ray_cast_3d.set_collision_mask_value(6,false)
	is_blueprint_active = false
	click_counter = 0
	
	
#region Iteractions with placed blueprints
var can_edit_blueprint = false

@onready var build_raycast_checker : Timer = $build_raycast_checker
func  enable_placed_blueprint_interactions():
	ray_cast_3d.set_collision_mask_value(2,true)
	build_raycast_checker.start()
	
func  disable_placed_blueprint_interactions():
	ray_cast_3d.set_collision_mask_value(2,false)
	build_raycast_checker.stop()
	
var already_placed_blueprint_on_view = null

func _on_build_raycast_checker_timeout():
#aca checkea bluepritns con los que pueda interactuar
	var blueprint_on_view = ray_cast_3d.get_collider()
	if blueprint_on_view != null:
		if already_placed_blueprint_on_view != blueprint_on_view.get_parent():
			already_placed_blueprint_on_view=blueprint_on_view.get_parent()
			player_build_menu.center_label.visible=true
			
	else :
		already_placed_blueprint_on_view = null
		player_build_menu.center_label.visible=false
		
#aca le da la orden que se mantenga resaltado
	if already_placed_blueprint_on_view !=null:
		already_placed_blueprint_on_view.building_construction_controls.resalt_blueprint()
		







#endregion
	
	
	
	
	
	
	
	
	
	
	
func place_blueprint():
	if can_be_blueprint_placed:
		player.ship.add_new_building(curret_build_blueprint_path,pointer_marker.global_position,exp_rot)
	
	
	
var rot_modifier = 0
func rotate_blueprint(val):
	rot_modifier+=deg_to_rad(90*val)

func update_pointer_pos():
	var spaceState=player.get_world_3d().direct_space_state
	var mousePos = Vector2(1366,768)/2
	var camera = get_tree().root.get_camera_3d()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) *2000
	var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd,CUSTOM.array_to_hex([7]))
	var rayArray = spaceState.intersect_ray(Parameters)
	print(rayArray.position)
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3.ZERO


