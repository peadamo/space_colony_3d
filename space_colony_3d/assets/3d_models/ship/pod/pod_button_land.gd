extends Node3D
@export var pod :CharacterBody3D 

func land_pod():
	print("land pod_button_pressed")
	pod.back_to_hangar()

