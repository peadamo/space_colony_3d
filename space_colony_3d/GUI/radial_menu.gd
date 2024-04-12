extends Control

var menu_items : Array = []
var mouse_angle
var screen_center

func _ready():
	screen_center = get_viewport_rect().size/2
	load_menu("start_menu")



var start_menu : Array = ["WALL","SYSTEM","FOOD","AIRLOCK","STORAGE"]
var current_menu

func load_menu(menu):
	var menu_to_load
	match menu:
		"start_menu":
			menu_to_load=start_menu
	current_menu=menu_to_load
	menu_items.clear()
	menu_items=menu_to_load
	set_up_items_layout()


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		mouse_angle= screen_center.angle_to_point(event.position)+deg_to_rad(90)
		if mouse_angle<0:
			mouse_angle+=deg_to_rad(360)
		rotate_position_marker()
		get_selected_item_by_angle()

	
var actual_angle=0.0
@onready var separators_bars = $separators_bars
var radial_Area_break_points:Array=[]

func set_up_items_layout():
	var items_count = menu_items.size()
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
		resalt_selected_item()
	
func resalt_selected_item():
	var all_items=item_images.get_children()
	for item in all_items:
		item.scale=Vector2(1,1)
		
	all_items[selected_item].scale=Vector2(2,2)
