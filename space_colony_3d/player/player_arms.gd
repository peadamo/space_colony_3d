extends Node3D
var state_machine : AnimationNodeStateMachinePlayback



func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	
	
func grab_gun():
	state_machine.travel("idle_gun")
	
func store_gun():
	state_machine.travel("IDLE")
	
	
func grab_book():
	state_machine.travel("carry")
	
func store_book():
	state_machine.travel("IDLE")
	
