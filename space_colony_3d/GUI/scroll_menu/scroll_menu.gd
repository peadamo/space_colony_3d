extends Control

var build_category : Array = [
	{"name":"Wall","image_path":"res://GUI/scroll_menu/icons/menu_icon_walls.png"},
	{"name":"Furniture","image_path":"res://GUI/scroll_menu/icons/menu_icon_furniture.png"},
	{"name":"Decorations","image_path":"res://GUI/scroll_menu/icons/menu_icon_decorations.png"},
	{"name":"Facility","image_path":"res://GUI/scroll_menu/icons/menu_icon_facility.png"},
	{"name":"Life Support","image_path":"res://GUI/scroll_menu/icons/menu_icon_lifeSupport.png"},
	{"name":"Power","image_path":"res://GUI/scroll_menu/icons/menu_icon_power.png"},
	{"name":"Resource","image_path":"res://GUI/scroll_menu/icons/menu_icon_resource.png"},
	{"name":"Food","image_path":"res://GUI/scroll_menu/icons/menu_icon_food.png"},
	{"name":"Storage","image_path":"res://GUI/scroll_menu/icons/menu_icon_storage.png"},
	{"name":"Airlock","image_path":"res://GUI/scroll_menu/icons/menu_icon_airlock.png"},
	{"name":"System","image_path":"res://GUI/scroll_menu/icons/menu_icon_system.png"},
	{"name":"Robots","image_path":"res://GUI/scroll_menu/icons/menu_icon_robots.png"},
]
@onready var menu_name_label = $main_menu/VBoxContainer/MarginContainer3/Menu_name/MarginContainer/ColorRect/MarginContainer2/menu_name_label
@onready var selected_item_image = $main_menu/VBoxContainer/MarginContainer2/sub_menu/HBoxContainer/selected_item/Item/Panel/selected_item_image

func _ready():
	
	load_menu(build_category)
	
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4 and event.pressed:
			pass
		if event.button_index == 5 and event.pressed:
			pass
	
var actual_index = 0
func load_menu(menu:Array):
	var menu_size=menu.size()
	var mid_menu_index = floori(menu_size/2.0)
	actual_index = mid_menu_index
	
	var selected_item_index = actual_index
	
	var left_1_index = actual_index - 1
	if left_1_index < 0 :
		left_1_index = menu_size - 1
		
	var left_2_index = actual_index - 2
	if left_2_index < 0 :
		left_2_index = menu_size - 2
	
	var rigth_1_index = actual_index + 1
	if rigth_1_index > menu_size-1 :
		rigth_1_index = 0
		
	var rigth_2_index = actual_index + 22
	if rigth_2_index > menu_size-1 :
		rigth_2_index = 1
		
	menu_name_label.text = str(menu[selected_item_index].name)
	selected_item_image.texture = load(menu[selected_item_index].image_path)
	
