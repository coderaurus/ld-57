extends Area2D
class_name Toy


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.get_toy()
		queue_free()
