extends Node
@onready var blue_print_controller = $"../bluePrint_controller"

func activate_construction_preview():
	blue_print_controller.blueprint_placed()



func resalt_blueprint():
	blue_print_controller.resalt_mesh_withe()
		

