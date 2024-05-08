extends Node

func clear_node_children(node_to_clean):
	var node_children = node_to_clean.get_children()
	for child in node_children:
		child.queue_free()


func array_to_hex(input_array : Array):
	var proceced_value
	#var binary_val = 0
	var bin_int_val = 0
	for value in input_array:
		#binary_val+= pow(10,value-1)
		bin_int_val+=pow(2,value-1)
		
	var format_string = "%x"
	var actual_string = str("0x",format_string % [bin_int_val])
	var final_val = int(actual_string)
	return final_val





	#pointer_marker.global_position=update_pointer_pos()
	##print(pointer_marker.global_position)
	#pass # Replace with function body.


#func update_pointer_pos():
	#var spaceState=player.get_world_3d().direct_space_state
	#var mousePos = Vector2(1366,768)/2
	#var camera = get_tree().root.get_camera_3d()
	#var rayOrigin = camera.project_ray_origin(mousePos)
	#var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) *2000
	#var Parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd,0xA)
	#var rayArray = spaceState.intersect_ray(Parameters)
	##print(rayArray)
	#if rayArray.has("position"):
		#return rayArray["position"]
	#return Vector3.ZERO



