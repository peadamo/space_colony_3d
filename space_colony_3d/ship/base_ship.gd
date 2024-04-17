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
	
	update_hull_walls()
	
func _ready():
	update_hull_walls()
	
	
	
func update_hull_walls():
	#print("ejecute delete internal hull walls")
	var floor_cells=$floor.get_children()
	var floor_cells_position : Array = []
	
	for cell in floor_cells:
		floor_cells_position.append(cell.global_position)
		
	
	var no_border_cells : Array = []
	var exist_counter=0
	for cell in floor_cells_position:
		
		var brother_cells : Array = [
			Vector3(cell.x + 1, 0 , cell.z + 1),
			Vector3(cell.x + 1, 0 , cell.z + 0),
			Vector3(cell.x + 1, 0 , cell.z - 1),
			
			Vector3(cell.x - 1, 0 , cell.z + 1),
			Vector3(cell.x - 1, 0 , cell.z + 0),
			Vector3(cell.x - 1, 0 , cell.z - 1),
			
			Vector3(cell.x + 0, 0 , cell.z + 1),
			Vector3(cell.x + 0, 0 , cell.z + 0),
			Vector3(cell.x + 0, 0 , cell.z - 1),
			
		]
		
		var is_border_cell = false
		
		for bcell in brother_cells:
			var exist = floor_cells_position.has(bcell)
			if exist == false:
				is_border_cell=true
			else:
				exist_counter+=1
		
		if is_border_cell == false:
			
			no_border_cells.append(cell)
	
	print(exist_counter)
	var wall_cells = $hull_walls.get_children()
	
	for wall_cell in wall_cells:
		var cell_pos = wall_cell.global_position
		if no_border_cells.has(cell_pos):
			wall_cell.queue_free()
			
	
