extends Area2D


func _on_body_entered(body):
	$AnimatedSprite2D.play("pickup")


func _on_animated_sprite_2d_animation_finished():
	queue_free()
