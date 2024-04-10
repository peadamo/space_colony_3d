extends Control

var mouse_position : Vector2 

@onready var tile_map :TileMap = $TileMap
@export var game_controller : Node

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1  and event.pressed:
			
			mouse_position = event.position
			
			write_tile()

var is_add_cell=true
func write_tile():
	var click_position=mouse_position
	click_position.x-=560
	click_position.y-=320
	var tilemap_cell = tile_map.local_to_map(click_position)
	
	if is_add_cell:

		var tilemap_cell_code = Vector2i(15,1)
		tile_map.set_cell(0,tilemap_cell,0,tilemap_cell_code)
		
		var is_wall=check_if_empty_cells_around(tilemap_cell)
		
		game_controller.add_ship_hull_cell(tilemap_cell,is_wall)
	else :
		tile_map.erase_cell(0,tilemap_cell)
		game_controller.remove_ship_hull_cell(tilemap_cell)


func check_if_empty_cells_around(cell):
	var is_wall=false
	var all_cells=tile_map.get_used_cells(0)
	var around_cells : Array = []
	around_cells.append(Vector2i(cell.x + 1 , cell.y + 1))
	around_cells.append(Vector2i(cell.x + 0 , cell.y + 1))
	around_cells.append(Vector2i(cell.x -1 , cell.y + 1))
	around_cells.append(Vector2i(cell.x + 1 , cell.y - 1))
	around_cells.append(Vector2i(cell.x + 0 , cell.y - 1))
	around_cells.append(Vector2i(cell.x - 1 , cell.y - 1))
	around_cells.append(Vector2i(cell.x - 1 , cell.y + 0))
	around_cells.append(Vector2i(cell.x + 1 , cell.y + 0))
	
	for a_cell in around_cells:
		var exist = all_cells.has(a_cell)
		if exist == false:
			is_wall = true
	
	return is_wall
	

func _on_add_hull_cell_button_pressed():
	is_add_cell = true


func _on_delete_hull_cell_button_pressed():
	is_add_cell = false
