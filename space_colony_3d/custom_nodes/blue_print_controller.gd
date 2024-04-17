extends Node3D

@export var mesh_container : Node3D
@export var mesh_container_01 : Node3D
@export var mesh_container_02 : Node3D

var object_meshes:Array=[]


func _ready():
	process_object_meshes()
	
	set_mesh_material_override(PROP_BLUEPRINT_GREEN)
	
const PROP_BLUEPRINT_GREEN = preload("res://shaders_and_materials/prop_blueprint_green.tres")
const PROP_BLUEPRINT_RED = preload("res://shaders_and_materials/prop_blueprint_red.tres")
const PROP_BLUEPRINT_SKYBLUE = preload("res://shaders_and_materials/prop_blueprint_skyblue.tres")

func process_object_meshes():
	if mesh_container != null:
		var meshInstances=mesh_container.get_children()
		for meshInstance:MeshInstance3D in meshInstances:
			object_meshes.append(meshInstance)
			
	if mesh_container_01 != null:
		var meshInstances=mesh_container_01.get_children()
		for meshInstance:MeshInstance3D in meshInstances:
			object_meshes.append(meshInstance)

	if mesh_container_02 != null:
		var meshInstances=mesh_container_02.get_children()
		for meshInstance:MeshInstance3D in meshInstances:
			object_meshes.append(meshInstance)


func set_mesh_material_override(new_material):
	for object_mesh in object_meshes:
		object_mesh.material_override=new_material
























@onready var blueprint_area_col_detector : Area3D = $blueprint_area_col_detector

func _on_timer_timeout():
	var has_collisions=false
	if blueprint_area_col_detector.has_overlapping_areas() or blueprint_area_col_detector.has_overlapping_bodies():
		has_collisions=true

	if has_collisions:
		#print(blueprint_area_col_detector.get_overlapping_areas())
		#print(blueprint_area_col_detector.get_overlapping_bodies())
		
		set_mesh_material_override(PROP_BLUEPRINT_RED)
		
	else:
		set_mesh_material_override(PROP_BLUEPRINT_GREEN)
@onready var timer = $Timer
@onready var collision_shape_3d = $blueprint_area_col_detector/CollisionShape3D

		
func blueprint_placed():
	timer.stop()
	set_mesh_material_override(PROP_BLUEPRINT_SKYBLUE)
	blueprint_area_col_detector.add_to_group("blue_print")
	
func build():
	collision_shape_3d.disabled=false
	set_mesh_material_override(null)
	queue_free()
