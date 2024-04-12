extends Node3D

@onready var grid_ship_floor = $grid_ship_floor
@onready var grid_ship_walls = $grid_ship_walls


func _ready():
	
	var grid_cells=grid_ship_walls.get_used_cells()
	for cell in grid_cells:
		var pos = grid_ship_floor.map_to_local(cell)
		print(pos)
		
		
		
func put_door(income_pos):
	var prop_position=income_pos
	#prop_position.x=int(prop_position.x)
	#prop_position.y=int(prop_position.y)
	#prop_position.z=int(prop_position.z)
	
	grid_cell=grid_ship_floor.map_to_local(prop_position)
	if prop_position.x<0:
		grid_cell.x-=2
	if prop_position.z<0:
		grid_cell.z-=2
	temp_prop_display(grid_cell)
	
func temp_prop_display(grid_cell):
	grid_ship_floor.clear()
	grid_ship_floor.set_cell_item(grid_cell,item_to_build,item_rotation)
	
var item_to_build=0
var grid_cell=Vector3.ZERO

func update_item_to_build(selected_item):
	item_to_build=selected_item

func confirm_build():
	grid_ship_walls.set_cell_item(grid_cell,item_to_build,item_rotation)
var item_rotation=0
func rotate_item(val):
	if val ==1 :
		item_rotation=16
	else:
		item_rotation = 0
	

func get_used_cells():
	var used_cells = grid_ship_walls.get_used_cells()
	return used_cells

func get_cell_item(cell : Vector3i):
	var item = grid_ship_walls.get_cell_item(cell)
	return item
