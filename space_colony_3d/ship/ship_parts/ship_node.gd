extends Node3D

@export var disable_collision = true
@onready var faces = $faces

# Called when the node enters the scene tree for the first time.

func _ready():
	if disable_collision:
		disable_collision_all_faces()
		
func disable_collision_all_faces():
	for child in faces.get_children():
		child.disable_face_collision()
		
func enable_collision_all_faces():
	for child in faces.get_children():
		child.enable_face_collision()
		
func get_ship_node_faces():
	var node_faces : Array = []
	for child in faces.get_children():
		node_faces.append(child)
	return node_faces
	
