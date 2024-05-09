extends Node3D
@onready var collision_shape_3d = $building_collision/CollisionShape3D

@export var auto_disble_collisions = true
var can_be_build = false

func _ready():
	if auto_disble_collisions:
		disable_face_collision()

func disable_face_collision():
	collision_shape_3d.disabled = true
	for cspot in $Construction_spots.get_children():
		cspot.collision_shape_3d.disabled=true

func set_spot_wall_data(data):
	for cspot in $Construction_spots.get_children():
		cspot.surface_type = data
