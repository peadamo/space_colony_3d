extends Node3D
@export var building:Node3D
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
const PROP_BLUEPRINT_WHITE = preload("res://shaders_and_materials/prop_blueprint_white.tres")
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

func resalt_mesh_withe():
	set_mesh_material_override(PROP_BLUEPRINT_WHITE)
	$Timer.start()

@onready var blueprint_area_col_detector : Area3D = $blueprint_area_col_detector

func _on_blueprint_area_col_detector_body_entered(body):
	set_mesh_material_override(PROP_BLUEPRINT_RED)
	building.can_be_build=false
	
func _on_blueprint_area_col_detector_body_exited(body):
	var colliding_bodies = blueprint_area_col_detector.get_overlapping_bodies()
	
	if colliding_bodies.size() == 0:
		set_mesh_material_override(PROP_BLUEPRINT_GREEN)
		building.can_be_build=true
		
@onready var collision_shape_3d = $blueprint_area_col_detector/CollisionShape3D

@onready var building_collision : StaticBody3D= $"../building_collision"
		
func blueprint_placed():
	blueprint_area_col_detector.monitoring = false
	set_mesh_material_override(PROP_BLUEPRINT_SKYBLUE)
	building_collision.set_collision_layer_value(2,true)


func _on_timer_timeout():
	set_mesh_material_override(PROP_BLUEPRINT_SKYBLUE)
	
func build_the_thing():
	$Timer.stop()
	set_mesh_material_override(null)
	blueprint_area_col_detector.monitoring = false
	building_collision.set_collision_layer_value(2,false)
	building_collision.set_collision_layer_value(1,true)
	
	
