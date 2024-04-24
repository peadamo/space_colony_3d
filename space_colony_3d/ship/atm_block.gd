extends Node3D

@onready var mesh_instance_3d :MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
#func _ready():
	#var material = mesh_instance_3d.mesh.surface_get_material(0)
	#var new_material = material.duplicate()
	#mesh_instance_3d.mesh.surface_set_material(0,new_material)
	#pass # Replace with function body.

@onready var label_3d :Label3D = $Label3D

func update_material(value):
	label_3d.text=str(floor( value))
	#var material :StandardMaterial3D = mesh_instance_3d.mesh.surface_get_material(0)
	#var new_material = material.duplicate()
	#
	#var max_oxi = 200.0
	#var alpha_value=value/max_oxi
	#print(alpha_value)
	#new_material.albedo_color = Color (0,0,0,1)
	#
	#mesh_instance_3d.mesh.surface_set_material(0,new_material)
	
	
