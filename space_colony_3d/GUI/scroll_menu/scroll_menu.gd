extends Control
@export var player : CharacterBody3D
const TEST_BUILDING = preload("res://ship/ship_buildings/test_build/test_building.tscn")
const OXIGEN_DISPENSER = preload("res://ship/ship_buildings/oxigen_dispenser/oxigen_dispenser.tscn")
const WALL_LAMP = preload("res://ship/ship_buildings/wall_lamp/wall_lamp.tscn")
@onready var subMenu_Airlock : Array = [
	{"name":"Pod Hangar","image":load("res://GUI/scroll_menu/icons/menu_building_PodHangar.png"),"submenu":null,"blueprint":WALL_LAMP},
	{"name":"Shuttle Hangar","image":load("res://GUI/scroll_menu/icons/menu_building_ShuttleHangar.png"),"submenu":null,"blueprint":OXIGEN_DISPENSER},
	{"name":"Space SuitLocker","image":load("res://GUI/scroll_menu/icons/menu_building_SpaceSuitLocker.png"),"submenu":null,"blueprint":OXIGEN_DISPENSER},
	{"name":"X1 Airlock","image":load("res://GUI/scroll_menu/icons/menu_building_X1Airlock.png"),"submenu":null,"blueprint":OXIGEN_DISPENSER},
]

@onready var subMenu_Power : Array = [
	{"name":"Small Power Node","image":load("res://GUI/scroll_menu/icons/menu_building_SmallPowerNode.png"),"submenu":null,"blueprint":TEST_BUILDING},
	{"name":"Large Power Node","image":load("res://GUI/scroll_menu/icons/menu_building_LargePowerNode.png"),"submenu":null,"blueprint":TEST_BUILDING},
	{"name":"Energium Power Generator","image":load("res://GUI/scroll_menu/icons/menu_building_EnergiumPowerGenerator.png"),"submenu":null,"blueprint":TEST_BUILDING},
	{"name":"X1 Power Generator","image":load("res://GUI/scroll_menu/icons/menu_building_X1PowerGenerator.png"),"submenu":null,"blueprint":TEST_BUILDING},
	{"name":"Power Capacity Node","image":load("res://GUI/scroll_menu/icons/menu_building_PowerCapacityNode.png"),"submenu":null,"blueprint":TEST_BUILDING},
	
]

@onready var build_category : Array = [
	{"name":"Wall","image":load("res://GUI/scroll_menu/icons/menu_icon_walls.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Furniture","image":load("res://GUI/scroll_menu/icons/menu_icon_furniture.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Decorations","image":load("res://GUI/scroll_menu/icons/menu_icon_decorations.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Facility","image":load("res://GUI/scroll_menu/icons/menu_icon_facility.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Life Support","image":load("res://GUI/scroll_menu/icons/menu_icon_lifeSupport.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Power","image":load("res://GUI/scroll_menu/icons/menu_icon_power.png"),"submenu":subMenu_Power,"blueprint":null},
	{"name":"Resource","image":load("res://GUI/scroll_menu/icons/menu_icon_resource.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Food","image":load("res://GUI/scroll_menu/icons/menu_icon_food.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Storage","image":load("res://GUI/scroll_menu/icons/menu_icon_storage.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Airlock","image":load("res://GUI/scroll_menu/icons/menu_icon_airlock.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"System","image":load("res://GUI/scroll_menu/icons/menu_icon_system.png"),"submenu":subMenu_Airlock,"blueprint":null},
	{"name":"Robots","image":load("res://GUI/scroll_menu/icons/menu_icon_robots.png"),"submenu":subMenu_Airlock,"blueprint":null},
]






@onready var preview_menu_margin_container = $main_menu/VBoxContainer/preview_menu_MarginContainer

@onready var preview_item_container = $main_menu/VBoxContainer/preview_menu_MarginContainer/preview_menu/VBoxContainer/preview_item_container

@onready var menu_name_label = $main_menu/VBoxContainer/MarginContainer3/Menu_name/MarginContainer/ColorRect/MarginContainer2/menu_name_label
@onready var selected_item_image = $main_menu/VBoxContainer/MarginContainer2/sub_menu/HBoxContainer/selected_item/Item/Panel/selected_item_image
@onready var left_1_image = $main_menu/VBoxContainer/MarginContainer2/sub_menu/HBoxContainer/left_1/Item/Panel/TextureRect
@onready var left_2_image = $main_menu/VBoxContainer/MarginContainer2/sub_menu/HBoxContainer/left_2/Item/Panel/TextureRect
@onready var rigth_1_image = $main_menu/VBoxContainer/MarginContainer2/sub_menu/HBoxContainer/rigth_1/Item/Panel/TextureRect
@onready var rigth_2_image = $main_menu/VBoxContainer/MarginContainer2/sub_menu/HBoxContainer/rigth_2/Item/Panel/TextureRect

@onready var center_label = $"info labels/center_label"

func _ready():
	$".".visible=false
	center_label.visible=false
	CUSTOM.clear_node_children(preview_item_container)
	initialize_menu(build_category)
	
var is_active = false

func show_build_menu():
	$".".visible=true
	is_active = true

func hide_build_menu():
	$".".visible=false
	is_active = false
	
	
func _unhandled_input(event):
	if is_active:
		if event is InputEventMouseButton:
			if event.button_index == 4 and event.pressed:
				actual_index += 1
				update_menu()
			if event.button_index == 5 and event.pressed:
				actual_index -= 1
				update_menu()
				
			if event.button_index == 2 and event.pressed:
				go_back_to_prev_menu()
				
			if event.button_index == 1 and event.pressed:
				print("scroll menu clik")
				process_select_actual_menu_item()
				
		#if event is InputEventKey:
			#if event.keycode == 70 and event.pressed:
				#process_select_actual_menu_item()
				
var actual_index = 0
var actual_index_modifier = 0
var actual_menu 
var menu_size
var prev_menu = build_category

func initialize_menu(menu):
	actual_menu = menu
	menu_size=actual_menu.size()
	var mid_menu_index = floori(menu_size/2.0)
	actual_index = mid_menu_index
	update_menu()
const PREVIEW_ITEM = preload("res://GUI/scroll_menu/preview_item.tscn")
func update_menu():
	
	if actual_index > menu_size-1:
		actual_index=0
	elif actual_index < 0 :
		actual_index = menu_size-1
	
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
	var rigth_2_index = actual_index + 2
	if rigth_2_index > menu_size-1 :
		rigth_2_index = 1
		
	menu_name_label.text = str(actual_menu[selected_item_index].name)
	selected_item_image.texture =actual_menu[selected_item_index].image
	left_1_image.texture =actual_menu[left_1_index].image
	left_2_image.texture =actual_menu[left_2_index].image
	rigth_1_image.texture =actual_menu[rigth_1_index].image
	rigth_2_image.texture =actual_menu[rigth_2_index].image
	
	CUSTOM.clear_node_children(preview_item_container)
	var submenu = actual_menu[actual_index].submenu
	if submenu !=null:
		preview_menu_margin_container.visible=true
		for item in submenu:
			preview_item_container.add_child(PREVIEW_ITEM.instantiate())
			var last_item = preview_item_container.get_child(-1)
			last_item.texture_rect.texture = item.image
	else:
		preview_menu_margin_container.visible=false
		var blueprint = actual_menu[selected_item_index].blueprint
		player.construction.load_blueprint(blueprint)

func process_select_actual_menu_item():
	var has_subMenu = false
	var submenu = actual_menu[actual_index].submenu
	
	if submenu != null :
		has_subMenu=true
	if has_subMenu:
		prev_menu=actual_menu
		initialize_menu(submenu)
		
	var has_blueprint = false
	var blueprint = actual_menu[actual_index].blueprint
	if blueprint != null :
		has_blueprint=true
		
	if has_blueprint:
		player.construction.load_blueprint(blueprint)
		player.construction.disable_placed_blueprint_interactions()
func go_back_to_prev_menu():
	if actual_menu == build_category:
		player.change_construction_mode_state()
	else :
		initialize_menu(prev_menu)
		player.construction.cancel_blueprint_display()
		player.construction.enable_placed_blueprint_interactions()
	
	
		
		
