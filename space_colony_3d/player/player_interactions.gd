extends Node
@export var player : CharacterBody3D
@onready var ray_cast_3d = $"../../head/head_camera/RayCast3D"




#
#func _unhandled_input(_event):
	#
	#if !player.is_in_pod:
		#
		#if Input.is_action_just_pressed("use_object"):
			#if player.looking_at_interactive_object:
				#player.interactive_object_in_view.use_object($".")
				#print("player use interactive object")
				#
			#if player.looking_at_hangar:
				#player.interactive_object_in_view.enter_pod($".")
				#
		##if Input.is_action_just_pressed("construction_mode"):
			##player.construction_mode_on=!player.construction_mode_on
			##if player.construction_mode_on :
				##$"../../head/head_camera/player_arms2".grab_gun()
				###ray_cast_3d.set_collision_mask_value(5, true)
				###player.build_menu.visible=true
			##else:
				##$"../../head/head_camera/player_arms2".store_gun()
				###ray_cast_3d.set_collision_mask_value(5, false)
				###player.build_menu.visible=false
				##
###esto es para cuando esta en el menu de cosntruccion
		##if player.construction_mode_on:
			##if event is InputEventMouseButton:
				##if event.button_index == 5 and event.pressed:
					##$Control/Build_menu/HBoxContainer.position.x-=100
					##pass
				##if event.button_index == 4 and event.pressed:
					##$Control/Build_menu/HBoxContainer.position.x+=100
					#
	#else:
		#if Input.is_action_just_pressed("use_object"):
			#if player.looking_at_interactive_object:
				#player.interactive_object_in_view.use_object()
				#print("player use interactive object")
				#
#func raycast_process():
	#
	#var raycastCollide=ray_cast_3d.get_collider()
	#
	#if raycastCollide != null:
		#$"../../Control/debug".text = str(raycastCollide)
		#if raycastCollide.is_in_group("interactive_object"):
			#player.interactive_object_in_view=raycastCollide
			#$"../../Control/Label".visible=true
			#$"../../Control/Label".text="Use"
			#player.looking_at_interactive_object=true
		#elif raycastCollide.is_in_group("blue_print"):
			#$"../../Control/Label".visible=true
			#$"../../Control/Label".text="Build"
			#player.looking_at_prebuild_object=true
			#player.interactive_object_in_view=raycastCollide.get_parent()
		#elif raycastCollide.is_in_group("building"):
			#$"../../Control/Label".visible=true
			#$"../../Control/Label".text="x to delete"
			#player.looking_at_building=true
			#player.interactive_object_in_view=raycastCollide.get_parent()
		#elif raycastCollide.is_in_group("hangar_door"):
			#$"../../Control/Label".visible=true
			#$"../../Control/Label".text="E to use pod"
			#player.looking_at_hangar=true
			#player.interactive_object_in_view=raycastCollide
		#elif raycastCollide.is_in_group("IT_wall_build_detector"):
			#$"../../Control/Label".visible=true
			#$"../../Control/Label".text="edit_wall"
			#player.looking_at_internalWall=true
			#player.interactive_object_in_view=raycastCollide.get_parent().get_parent()
			#player.interactive_object_in_view.show_blueprint()
			#
			#
		#else :
			#player.looking_at_interactive_object=false
			#player.looking_at_prebuild_object=false
			#player.looking_at_building=false
			#player.looking_at_hangar=false
			#player.looking_at_internalWall=false
			#$"../../Control/Label".visible=false
#
#func calc_pointer_ref_position():
	#var new_position=update_pointer_pos()
	#var cal_corrected_position = round(new_position)
	#if cal_corrected_position != corrected_position:
		#corrected_position=cal_corrected_position
		#update_mesh_ref_position()
#
#var corrected_position
#
#func update_mesh_ref_position():
	#if player.is_floor_blue_print:
		#player.pointer_marker.global_position=Vector3(corrected_position.x,corrected_position.y,corrected_position.z)
	#else:
		#player.pointer_marker.global_position=corrected_position
	#
#func update_pointer_pos():
	#var spaceState=player.get_world_3d().direct_space_state
	#var mousePos = Vector2(1152.0/2,648.0/2)
	#var camera = get_tree().root.get_camera_3d()
	#var rayOrigin = camera.project_ray_origin(mousePos)
	#var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) *2000
	#var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd,0xA)
	#var rayArray = spaceState.intersect_ray(Parameters)
	#if rayArray.has("position"):
		#return rayArray["position"]
	#return Vector3.ZERO
#
#
#
#
#func _on_timer_timeout():
	#raycast_process()
