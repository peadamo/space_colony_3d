extends Node3D
@export var pod :CharacterBody3D 

func lunch_pod():
	print("lunch pod_button_pressed")
	pod.start_lunch()
