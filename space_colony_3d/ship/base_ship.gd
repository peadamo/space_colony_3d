extends Node3D
@onready var ship_buildings = $ship_buildings
@onready var floor = $floor
@onready var hull_walls = $hull_walls

func ship_get_floor_nodes():
	return $floor.get_children()

var floor_meshes:Array=[]

var x_ray_meshes : Array = []

const PROP_BLUEPRINT_SKYBLUE = preload("res://shaders_and_materials/prop_blueprint_skyblue.tres")
@onready var roof = $roof

func active_xView_vision():
	x_ray_meshes.clear()
	
	var wall_nodes=hull_walls.get_children()
	for node in wall_nodes:
		var node_children = node.get_children()
		var node_mesh_container = null
		
		for children in node_children:
			if children.is_in_group("mesh_container"):
				node_mesh_container=children
		
		if node_mesh_container != null :
			var mesh_container_children = node_mesh_container.get_children()
			for mesh in mesh_container_children:
				x_ray_meshes.append(mesh)
				
	var roof_nodes=roof.get_children()
	for node in roof_nodes:
		var node_children = node.get_children()
		var node_mesh_container = null
		
		for children in node_children:
			if children.is_in_group("mesh_container"):
				node_mesh_container=children
		
		if node_mesh_container != null :
			var mesh_container_children = node_mesh_container.get_children()
			for mesh in mesh_container_children:
				x_ray_meshes.append(mesh)
				
				
				
				
				
				
				
				
	for mesh in x_ray_meshes:
		mesh.material_override=PROP_BLUEPRINT_SKYBLUE
	
func inactive_xView_vision():
	for mesh in x_ray_meshes:
		mesh.material_override=null
