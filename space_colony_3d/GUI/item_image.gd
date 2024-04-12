extends Node2D
@onready var label = $Label

func set_up(menu_item):
	label.text=menu_item
