extends Node3D
var state_machine : AnimationNodeStateMachinePlayback



func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	

func get_walk():
	state_machine.travel("walk")
func get_idle():
	state_machine.travel("IDLE")
	
