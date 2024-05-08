extends Node3D
@onready var building_construction_controls = $building_construction_controls
@onready var meshes = $meshes

#this value change to false if the blueprint is colliding with some shit
#so you cannot place a colliding blueprint, genius
@onready var can_be_build = true
