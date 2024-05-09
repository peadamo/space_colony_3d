extends Node3D
@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D

func disable_face_collision():
	collision_shape_3d.disabled = true
	for cspot in $Construction_spots.get_children():
		cspot.collision_shape_3d.disabled=true

func set_spot_wall_data(data):
	for cspot in $Construction_spots.get_children():
		cspot.surface_type = data
