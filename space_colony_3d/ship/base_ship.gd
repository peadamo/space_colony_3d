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
	
	var shipCell = ship_cells[shipCells_get_position_index(pos,true)]
	shipCell.hull=true
	shipCell.hull_wall_node=last_wall
	shipCell.floor=true
	print("construido  ",pos , shipCell)
	
	#update_hull_walls()
	
	
var ship_cells : Array = []
var ship_max_size = 26


func _ready():
	
	for x in ship_max_size+1:
		var x_val = -ship_max_size/2 + x
		for z in ship_max_size+1:
			var z_val = -ship_max_size/2 + z
			ship_cells.append({"pos": Vector3(x_val,0,z_val), "hull" : false, "hull_wall_node" : null, "floor" : false})
				
				
<<<<<<< HEAD
	#get_used_cells()
	##
	#generate_ATM_cells()
=======
	get_used_cells()
	
	generate_ATM_cells()
>>>>>>> parent of 52538fe (experimenting wit 3x3 hull module)
	
	#update_hull_walls()
	
var atm_cells : Array = []
const ATM_BLOCK = preload("res://ship/atm_block.tscn")	
@onready var gases_blocks = $Gases_blocks

func generate_ATM_cells():
	
	
	for x in ship_max_size+1:
		var x_val = -ship_max_size/2 + x
		for z in ship_max_size+1:
			var z_val = -ship_max_size/2 + z
			atm_cells.append({"exist":false ,"pos":Vector3(x_val,0,z_val),"node":null,"nearCells":[],"oxi":0.0})
	
	for i in atm_cells.size():
		var cell = atm_cells[i]
		var ship_cell = ship_cells[i]
		
		if ship_cell.floor and !ship_cell.hull:
			gases_blocks.add_child(ATM_BLOCK.instantiate())
			var new_gas_block=gases_blocks.get_child(-1)
			new_gas_block.position=cell.pos
			cell.node=new_gas_block
			cell.exist=true
			
			
			
		cell.nearCells.append(find_near_atm_cells(cell.pos.x -1 , cell.pos.y , cell.pos.z -1 ))
		cell.nearCells.append(find_near_atm_cells(cell.pos.x , cell.pos.y , cell.pos.z -1 ))
		cell.nearCells.append(find_near_atm_cells(cell.pos.x +1 , cell.pos.y , cell.pos.z -1 ))
		cell.nearCells.append(find_near_atm_cells(cell.pos.x -1 , cell.pos.y , cell.pos.z +1 ))
		cell.nearCells.append(find_near_atm_cells(cell.pos.x , cell.pos.y , cell.pos.z +1 ))
		cell.nearCells.append(find_near_atm_cells(cell.pos.x +1 , cell.pos.y , cell.pos.z +1 ))
		cell.nearCells.append(find_near_atm_cells(cell.pos.x -1 , cell.pos.y , cell.pos.z  ))
		cell.nearCells.append(find_near_atm_cells(cell.pos.x +1 , cell.pos.y , cell.pos.z  ))
		
		
		
		
		
		
		
		
		
		
func find_near_atm_cells(x,y,z):
	for i in atm_cells.size():
		var cell = atm_cells[i]
		if cell.pos == Vector3(x,y,z):
			return i
	return null
	
		
	
func get_used_cells():
	
	var wall_cells= $hull_walls.get_children()
	
	for wall in wall_cells:
		var wall_pos = wall.global_position
		ship_cells[shipCells_get_position_index(wall_pos)].hull = true
		ship_cells[shipCells_get_position_index(wall_pos)].hull_wall_node = wall
		
		
	var floor_cells = $floor.get_children()
	for flo in floor_cells:
		var floor_pos = flo.global_position
		ship_cells[shipCells_get_position_index(floor_pos)].floor = true
	
	return ship_cells
func update_hull_walls():
	var total_hull=0

	for i in ship_cells.size():
		
		var cell = ship_cells[i]
		if cell.floor:
			#print(cell)
			pass
		
		
		
		if cell.hull:
			total_hull+=1
			var cp=cell.pos
			var closer_cells : Array = [
				shipCells_get_position_index(Vector3(cp.x + 0 , 0 , cp.z + 1)),
				shipCells_get_position_index(Vector3(cp.x + 0 , 0 , cp.z + 0)),
				shipCells_get_position_index(Vector3(cp.x + 0 , 0 , cp.z - 1)),
				shipCells_get_position_index(Vector3(cp.x - 1 , 0 , cp.z + 1)),
				shipCells_get_position_index(Vector3(cp.x - 1 , 0 , cp.z + 0)),
				shipCells_get_position_index(Vector3(cp.x - 1 , 0 , cp.z - 1)),
				shipCells_get_position_index(Vector3(cp.x + 1 , 0 , cp.z + 1)),
				shipCells_get_position_index(Vector3(cp.x + 1 , 0 , cp.z + 0)),
				shipCells_get_position_index(Vector3(cp.x + 1 , 0 , cp.z - 1)),
			]
			var closer_floor_count=0
			for closerCell in closer_cells:
				if ship_cells[closerCell].floor:
					closer_floor_count+=1
					
			#print(cp,"-",closer_floor_count)
			if closer_floor_count == 9:
				cell.hull_wall_node.queue_free()
				cell.hull=false
	#print(total_hull)
func shipCells_get_position_index(cell_pos:Vector3, log:bool = false):
	var cell_index = null
	cell_pos.x = round(cell_pos.x)
	cell_pos.y = round(cell_pos.y)
	cell_pos.z = round(cell_pos.z)
	
	
	
	
	
	for i in ship_cells.size():
		var cell = ship_cells[i]
		#cell_pos=Vector3(cell_pos.x,cell_pos.y,cell_pos.z)
		if cell.pos == cell_pos:
			cell_index = i
			break
	
	if cell_index == null :
		print(" x : ",cell_pos.x," y : ",cell_pos.y," z : ",cell_pos.z)
		cell_index = 0
		
	if log:
		print("get_index",cell_pos,ship_cells[cell_index])
	return cell_index
@onready var player = $"../Player"
func free_player(pos):
	player.reparent($"..")
	player.leave_pod(pos)
var generate_oxi=false

func _on_atm_updater_timeout():
	#print("atm update")
	var total_oxi=0
	for cell in atm_cells:
		
		if cell.exist:
			
			if generate_oxi:
				cell.oxi+=3200*4
				generate_oxi=false
				
			if cell.oxi > -1000:
				var cells_to_share=0
				for i in cell.nearCells:
					if i != null:
						var ncell=atm_cells[i]
						if ncell.exist:
							cells_to_share+=1
							
				var oxi_share = cell.oxi/(cells_to_share+1)
				
				for i in cell.nearCells:
					if i != null:
						var ncell=atm_cells[i]
						if ncell.exist:
							ncell.oxi += oxi_share
							cell.oxi -= oxi_share
							
			

						
			cell.node.update_material(cell.oxi)
			#print(cell.oxi)
			
	var existing_ells=0
	for cell in atm_cells:
		if cell.exist:
			total_oxi+=cell.oxi
			existing_ells+=1
			
			
	#print("total oxi: ",total_oxi, " - cells : ",existing_ells, " - oxi -er cell: ", total_oxi/existing_ells)

func get_atm_cell_by_pos(pos :Vector3):
	var cell_pos=pos
	cell_pos.x = round(cell_pos.x)
	cell_pos.y = 0.0
	cell_pos.z = round(cell_pos.z)
	
	
	for cell in atm_cells:
		if cell.pos == cell_pos:
			return cell
	
	return null
