extends Camera2D

@export var target: Node2D

func _process(delta: float) -> void:
	if target != null:
		global_position = target.global_position
