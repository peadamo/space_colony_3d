extends Node3D
@onready var ship_buildings = $ship_buildings
@onready var floor = $floor

func ship_get_floor_nodes():
	return $floor.get_children()

var floor_meshes:Array=[]

func active_xView_vision():
	var floor_nodes=ship_get_floor_nodes()
	print("x_vision")
	
