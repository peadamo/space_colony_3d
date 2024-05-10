extends StaticBody3D
@export var ship_node_face :  Node3D
@onready var wall_position_marker = $wall_position_marker

func add_construction(cosntruction_scene:PackedScene):
	ship_node_face.delete_construction()
	ship_node_face.construction.add_child(cosntruction_scene.instantiate())
	var last_construction = ship_node_face.construction.get_child(-1)
	last_construction.place_blueprint()
	last_construction.config_wall_layers()
	
