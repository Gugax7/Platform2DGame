extends Area2D



func _on_area_entered(area):
	if area.name == "hurtbox":
		area.get_parent().hit()
		
