extends Node3D
@onready var ship_buildings = $ship_buildings

@onready var internal_walls = $internal_walls

@onready var hull = $hull



func _ready():
# borra las paredes internadas de los hull nodes creados a mano
	get_ship_nodes_faces()
	print(ship_node_faces.size())
	for face in ship_node_faces:
		delete_internal_wall(face)

#region Hull node construction
var ship_node_faces : Array = []

func get_ship_nodes_faces():
	var ship_modes = hull.get_children()
	for ship_node in ship_modes:
		var node_faces = ship_node.get_ship_node_faces()
		for face in node_faces:
			ship_node_faces.append(face)
			
func add_new_ship_node_faces(ship_node):
	var node_faces = ship_node.get_ship_node_faces()
	print(ship_node)
	for face in node_faces:
		ship_node_faces.append(face)
		
	for face in ship_node_faces:
		delete_internal_wall(face)
		
		
func delete_internal_wall(eval_face):
	for face in ship_node_faces:
		if face != eval_face:
			if round(face.global_position) == round(eval_face.global_position):
				print("deleted",eval_face,face)
				eval_face.disable_face_collision()
				eval_face.delete_construction()
	
	pass
#endregion

@onready var player = $"../Player"
func free_player(pos):
	player.reparent($"..")
	player.leave_pod(pos)

