extends Node3D


@onready var near_hull_nodes = {
	"floor" : null ,
	"roof" : null ,
	"north" : null ,
	"south" : null ,
	"east" : null ,
	"west" : null ,
}

@onready var self_lateral_hull_node_markers = {
	"floor" : $floor/floor_collider/lateral_block_pos ,
	"roof" : $roof/roof_collider/lateral_block_pos ,
	"north" : $north_wall/wall_01_collider/lateral_block_pos ,
	"south" : $south_wall/wall_02_collider/lateral_block_pos ,
	"east" : $east_wall/wall_03_collider/lateral_block_pos ,
	"west" : $west_wall/wall_04_collider/lateral_block_pos ,
}


func delete_north_wall():
	$"north_wall/3x3 wall01".visible=false
	$north_wall/wall_01_collider/CollisionShape3D.disabled = true
	
func delete_south_wall():
	$"south_wall/3x3 wall01".visible=false
	$south_wall/wall_02_collider/CollisionShape3D.disabled = true
	
func delete_east_wall():
	$"east_wall/3x3 wall01".visible=false
	$east_wall/wall_03_collider/CollisionShape3D.disabled = true
	
func delete_west_wall():
	$"west_wall/3x3 wall01".visible=false
	$west_wall/wall_04_collider/CollisionShape3D.disabled = true

