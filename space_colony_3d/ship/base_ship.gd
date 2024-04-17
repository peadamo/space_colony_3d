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
		
		
const FLOOR_00 = preload("res://assets/3d_models/ship/floor/floor_00.tscn")		
const HULL_WALL = preload("res://assets/3d_models/ship/hull_wall/hull_wall.tscn")
const ROOF_00 = preload("res://assets/3d_models/ship/roof/roof_00.tscn")
const HULL_BLUEPRINT_WITH_WALL = preload("res://assets/3d_models/ship/hull_blueprint/hull_blueprint_with_wall.tscn")
@onready var hull_blueprint = $hull_blueprint

func add_hull_wall_blueprint(position):
	hull_blueprint.add_child(HULL_BLUEPRINT_WITH_WALL.instantiate())
	var last_child=hull_blueprint.get_child(-1)
	last_child.global_position=position
	last_child.write_blueprint()
	
	
	
func add_hull_wall(pos):
	
	hull_walls.add_child(HULL_WALL.instantiate())
	var last_wall=hull_walls.get_child(-1)
	last_wall.global_position=pos
	
	floor.add_child(FLOOR_00.instantiate())
	var last_floor=floor.get_child(-1)
	last_floor.global_position=pos
	
	roof.add_child(ROOF_00.instantiate())
	var last_roof=roof.get_child(-1)
	last_roof.global_position=pos
	
func _ready():
	update_hull_walls()
	
func update_hull_walls():
	var floor_cells=$floor.get_children()
	var floor_cells_position : Array = []
	
	for cell in floor_cells:
		floor_cells_position.append(cell.global_position)
	
	var no_border_cells : Array = []
	
	for cell in floor_cells_position:
		var is_border_cell = false
		
		if !floor_cells_position.has(Vector3(cell.x+1,cell.y,cell.z)):
			is_border_cell=true
			print(is_border_cell)

		if !floor_cells_position.has(Vector3(cell.x-1,cell.y,cell.z)):
			is_border_cell=true
			print(is_border_cell)

		if !floor_cells_position.has(Vector3(cell.x+1,cell.y+1,cell.z)):
			is_border_cell=true
			print(is_border_cell)

		if !floor_cells_position.has(Vector3(cell.x-1,cell.y+1,cell.z)):
			is_border_cell=true
			print(is_border_cell)

		if !floor_cells_position.has(Vector3(cell.x,cell.y+1,cell.z)):
			is_border_cell=true
			print(is_border_cell)

		if !floor_cells_position.has(Vector3(cell.x+1,cell.y-1,cell.z)):
			is_border_cell=true
			print(is_border_cell)

		if !floor_cells_position.has(Vector3(cell.x-1,cell.y-1,cell.z)):
			is_border_cell=true
			print(is_border_cell)
	
		if !floor_cells_position.has(Vector3(cell.x,cell.y-1,cell.z)):
			is_border_cell=true
			print(is_border_cell)
			
		if !is_border_cell:
			no_border_cells.append(cell)
		
	print(no_border_cells)
