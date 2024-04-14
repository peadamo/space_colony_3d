extends Node





var ship_tilemap : Array =[]
@onready var base_ship = $BaseShip
#@onready var tile_map = $BaseShip/ship_buildings/main_console/screens/PanelContent/SubViewport/ShipBlueprint/TileMap
#
#func update_tile_map():
	#var all_ship_used_cells=base_ship.get_used_cells()
	#var level_0_used_cells : Array = []
	#
	#for cell in all_ship_used_cells:
		#if cell.y == 0 :
			#level_0_used_cells.append(cell)
			#
	#var level_0_cell_item : Array = []
	#
	#for cell in level_0_used_cells:
		#var item = base_ship.get_cell_item(cell)
		#level_0_cell_item.append(item)
		#
		#var tilemap_cell:Vector2i
		#
		#if item == 0:
			#tilemap_cell=Vector2i(15,1)
		#elif item == 1:
			#tilemap_cell=Vector2i(12,1)
		#elif item == 2:
			#tilemap_cell=Vector2i(18,1)
			#
		#tile_map.set_cell(0,Vector2i(cell.x,cell.z),0,tilemap_cell)
		#print("se cambio tile")
		#
	#print(level_0_cell_item)
	#
	#
@onready var grid_ship_walls : GridMap = $BaseShip/grid_ship_walls
@onready var grid_ship_roof = $BaseShip/grid_ship_roof
	
func add_ship_hull_cell(tilemap_cell,is_wall):
	#print("grid_cell", )
	if is_wall:
		grid_ship_walls.set_cell_item(Vector3i(tilemap_cell.x,0,tilemap_cell.y),1,0)
	else :
		grid_ship_walls.set_cell_item(Vector3i(tilemap_cell.x,0,tilemap_cell.y),0,0)
	
	grid_ship_roof.set_cell_item(Vector3i(tilemap_cell.x,0,tilemap_cell.y),4,0)
	
	
func remove_ship_hull_cell(tilemap_cell):
	grid_ship_walls.set_cell_item(Vector3i(tilemap_cell.x,0,tilemap_cell.y),-1,0)
	grid_ship_roof.set_cell_item(Vector3i(tilemap_cell.x,0,tilemap_cell.y),-1,0)
	
	
