extends Area2D

func _on_Area2D_area_entered(area):
	print("something is near")
	while area:
		if area.is_in_group("player"):
			get_tree().call_group("enemies", "shoot()")

