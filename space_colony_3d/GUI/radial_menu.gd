extends Control
@export var player:CharacterBody3D
var menu_items : Array = []
var mouse_angle
var screen_center
var is_radial_menu_on=false

func _ready():
	screen_center = get_viewport_rect().size/2



var start_menu : Array = ["WALL","SYSTEM","FOOD","AIRLOCK","STORAGE","VITAL SUPPORT"]
var food_menu : Array = ["DISPENSER_ALGAS","COCINA","MESA CULTIVO CHICA", "MESA CULTIVO MEDIANA", "MESA CULTIVO GRANDE", "GENERADOR DE CO2"]
var airlock_menu : Array = ["Pod Hangar", "Shuttle Hangar","X1 Airlock","Space Suit Locker"]
var life_support_menu : Array = ["Oxygen Generator", "Thermal Regulators","Gas Scrubber","Air Vent"]

var current_menu

func load_menu(menu):
	
	var menu_to_load : Array
	match menu:
		"start_menu":
			menu_to_load.append_array(start_menu)
		"food_menu":
			menu_to_load.append_array(food_menu)
		"airlock_menu":
			menu_to_load.append_array(airlock_menu)
		"life_support_menu":
			menu_to_load.append_array(life_support_menu)
			
			
			
			
	current_menu=menu_to_load
	menu_items.clear()
	menu_items=menu_to_load
	CUSTOM.clear_node_children(item_images)
	CUSTOM.clear_node_children(separators_bars)
	set_up_items_layout(menu_items)


func _unhandled_input(event):
	if is_radial_menu_on:
		if event is InputEventMouseMotion:
			mouse_angle= screen_center.angle_to_point(event.position)+deg_to_rad(90)
			if mouse_angle<0:
				mouse_angle+=deg_to_rad(360)
			rotate_position_marker()
			get_selected_item_by_angle()
			
		if event is InputEventMouseButton:
			if event.button_index==1 and event.pressed:
				run_action_selected_menu()

func run_action_selected_menu():
	var item_menu=current_menu[selected_item]
	match item_menu:
		"WALL":
			player.load_blueprint("basic_wall",true)
		"SYSTEM":
			pass
		"FOOD":
			load_menu("food_menu")
		"AIRLOCK":
			load_menu("airlock_menu")
		"STORAGE":
			pass
		"VITAL SUPPORT":
			load_menu("life_support_menu")
#airlock MENU ITEMS:
		"Pod Hangar":
			player.load_blueprint("Pod Hangar",true)
		"Shuttle Hangar":
			pass
		"X1 Airlock":
			pass
		"Space Suit Locker":
			pass
#vital suport
		"Oxygen Generator":
			player.load_blueprint("Oxygen Generator",true)

	
var actual_angle=0.0
@onready var separators_bars = $separators_bars
var radial_Area_break_points:Array=[]

func set_up_items_layout(new_menu_items):
	radial_Area_break_points.clear()
	var items_count = new_menu_items.size()
	var radial_dist = deg_to_rad(360)/items_count
	for i in items_count:
		var separator_bar_scne = load("res://GUI/separator_bar.tscn")
		separators_bars.add_child(separator_bar_scne.instantiate())
		var new_separator=separators_bars.get_child(-1)
		new_separator.rotation=radial_dist*i
		load_item_content(radial_dist,i)
		radial_Area_break_points.append(radial_dist*i)
		
@onready var position_marker = $position_marker

func rotate_position_marker():
	position_marker.rotation=mouse_angle
	
var initial_image_pos=Vector2(0,-180)
@onready var item_images = $item_images
func load_item_content(radial_dist,i):
	var item_image = load("res://GUI/item_image.tscn")
	item_images.add_child(item_image.instantiate())
	var last_item = item_images.get_child(-1)
	var rotation_angle=deg_to_rad(90)
	var rotated = initial_image_pos.rotated(radial_dist/2+radial_dist*i)
	last_item.position=rotated+screen_center
	last_item.set_up(current_menu[i])
var selected_item=0
	
func get_selected_item_by_angle():
	var actual_angle=mouse_angle
	var item=0
	for i in radial_Area_break_points.size():
		var point = radial_Area_break_points[i]
		if actual_angle>point:
			item=i
	if item != selected_item:
		selected_item=item
		
		for child in item_images.get_children():
			child.scale=Vector2(1,1)
		item_images.get_children()[item].scale=Vector2(2,2)
	
	

