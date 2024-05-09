extends Node3D
@onready var building_construction_controls = $building_construction_controls

@onready var meshes = $mesh

const escene_ref = preload("res://ship/ship_buildings/wall_lamp/wall_lamp.tscn")
#this value change to false if the blueprint is colliding with some shit
#so you cannot place a colliding blueprint, genius
@onready var can_be_build = true

var blueprint_admited_surface_type : Array = ["floor","roof","wall"]
