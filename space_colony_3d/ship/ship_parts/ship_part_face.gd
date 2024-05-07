extends StaticBody3D

@export var is_cube = false
@export var is_prism_3x3 = false
@export var is_prism_3x6 = false
@export var is_wall = false
@export var is_floor = false
@export var is_roof = false
@export var is_squere_face = false



func _ready():
	if is_squere_face:
		if !is_wall:
			$interaction_detectors/IT_wall_build_detector.queue_free()

func get_new_shipNode_position():
	return $Marker3D.global_position

func get_ship_node_blueprint_scene():
	if is_cube:
		return "CUBE"
	elif is_prism_3x3:
		return "PRISM_3X3"
	elif is_prism_3x6:
		return "PRISM_3X6"
@onready var collision_shape_3d = $CollisionShape3D
	
func disable_face_collision():
	collision_shape_3d.disabled = true
	$construction/metal_plate_wall.disable_face_collision()
	
func enable_face_collision():
	collision_shape_3d.disabled = false
@onready var construction = $construction
	
func delete_construction():
	construction.visible=false
	#CUSTOM.clear_node_children(construction)
	
func show_blueprint():
	construction.visible = true
	$construction/Timer.start()

func _on_timer_timeout():
	delete_construction()
