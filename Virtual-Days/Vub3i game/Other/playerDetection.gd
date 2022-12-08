extends Area2D


func area_shape_entered(area_shape_index):
	print("something is near")
	if area_shape_index.is_in_group("player"):
		get_tree().call_group("enemies", "_on_collision")


