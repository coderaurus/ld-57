extends Area2D
class_name Goal

signal goal_reached

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		goal_reached.emit()
