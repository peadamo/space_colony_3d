extends Node2D

func set_image(image_path):
	var image = load(image_path)
	$item_image.texture=image
