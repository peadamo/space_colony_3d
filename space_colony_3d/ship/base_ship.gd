extends Node3D

@onready var grid_ship_floor = $grid_ship_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	var floor_cells=grid_ship_floor.get_used_cells()
	print(floor_cells)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
