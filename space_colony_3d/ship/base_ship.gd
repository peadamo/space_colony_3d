extends Node3D
@onready var ship_buildings = $ship_buildings


@onready var hull = $hull

func _ready():

# borra las paredes internadas de los hull nodes creados a mano
	for hullNode in hull.get_children():
		auto_delete_internal_walls(hullNode)
		

#region Hull node construction


func auto_delete_internal_walls(hullNode):
#Elimina las pararedes del hull node que tengan otro nodo como vecino, y asigna los vecinos.
	
	var hullNode_north_marker = round(hullNode.self_lateral_hull_node_markers.north.global_position)
	var hullNode_south_marker = round(hullNode.self_lateral_hull_node_markers.south.global_position)
	var hullNode_east_marker = round(hullNode.self_lateral_hull_node_markers.east.global_position)
	var hullNode_west_marker = round(hullNode.self_lateral_hull_node_markers.west.global_position)
	
	
	
	for eval_hullNode in hull.get_children():
		var eval_pos = round(eval_hullNode.global_position)
		if eval_pos == hullNode_north_marker:
			hullNode.near_hull_nodes.north=eval_hullNode
			hullNode.delete_north_wall()
			eval_hullNode.near_hull_nodes.south = hullNode
			eval_hullNode.delete_south_wall()
			
		elif eval_pos == hullNode_south_marker:
			hullNode.near_hull_nodes.south=eval_hullNode
			hullNode.delete_south_wall()
			eval_hullNode.near_hull_nodes.north = hullNode
			eval_hullNode.delete_north_wall()
			
		elif eval_pos == hullNode_east_marker:
			hullNode.near_hull_nodes.east=eval_hullNode
			hullNode.delete_east_wall()
			eval_hullNode.near_hull_nodes.west = hullNode
			eval_hullNode.delete_west_wall()
			
			
		elif eval_pos == hullNode_west_marker:
			hullNode.near_hull_nodes.west=eval_hullNode
			hullNode.delete_west_wall()
			eval_hullNode.near_hull_nodes.east = hullNode
			eval_hullNode.delete_east_wall()





@onready var hull_blueprint = $hull_blueprint
const HULL_3X_3_BLUEPRINT = preload("res://assets/3d_models/ship/hull_modules/HULL 3x3 blueprint.tscn")
func add_hull_wall_blueprint(new_pos):
	hull_blueprint.add_child(HULL_3X_3_BLUEPRINT.instantiate())
	var last_child=hull_blueprint.get_child(-1)
	last_child.global_position=new_pos
	last_child.write_blueprint()
	
const HULL_3X_3 = preload("res://assets/3d_models/ship/hull_modules/hull_3x3.tscn")	
func add_hull_wall(pos):
	hull.add_child(HULL_3X_3.instantiate())
	var last_hull_node = hull.get_child(-1)
	last_hull_node.global_position=pos
	auto_delete_internal_walls(last_hull_node)
	
#endregion

@onready var player = $"../Player"
func free_player(pos):
	player.reparent($"..")
	player.leave_pod(pos)

