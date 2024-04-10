extends Node3D

@onready var on_use_position_marker = $on_use_position_marker

func use_object(player):
	player.global_position=on_use_position_marker.global_position
	player.can_move=false
	player.can_move_head=false
	player.can_move_head_default=false
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

@onready var panel = $screens/PanelContent/SubViewport/Panel
@onready var ship_blueprint = $screens/PanelContent/SubViewport/ShipBlueprint


func show_test():
	ship_blueprint.visible=false
	panel.visible=true
	print("show test")
	
func show_blueprint():
	ship_blueprint.visible=true
	panel.visible=false
	print("show test")
