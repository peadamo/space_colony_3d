extends Node

var rts_view_on=false
@onready var rts_view = $RtsView
@onready var player = $Player


func _input(event):
	
	if Input.is_action_just_pressed("rts_view"):
		rts_view_on=!rts_view_on
		if rts_view_on:
			rts_view.set_control_on()
			player.set_control_off()
		else :
			player.set_control_on()
			rts_view.set_control_off()



