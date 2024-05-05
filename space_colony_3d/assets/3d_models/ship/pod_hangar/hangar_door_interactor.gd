extends Area3D
@export var pod:CharacterBody3D

func enter_pod(player):
	player.reparent(pod.player_holder)
	player.get_into_pod()
	pass
