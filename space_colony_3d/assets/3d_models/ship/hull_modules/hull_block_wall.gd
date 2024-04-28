extends StaticBody3D

@onready var lateral_block_pos = $lateral_block_pos

func get_blueprint_position():
	return lateral_block_pos.global_position
