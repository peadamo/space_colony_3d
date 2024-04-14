extends Node

func clear_node_children(node_to_clean):
	var node_children = node_to_clean.get_children()
	for child in node_children:
		child.queue_free()
