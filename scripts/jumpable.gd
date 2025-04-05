extends StaticBody2D
class_name Jumpable

@onready var jump_points: Line2D = $JumpPoints

@export var can_be_picked: bool = false

func get_jump_path() -> PackedVector2Array:
	return $JumpPoints.points

func set_jump_direction(direction: Vector2) -> void:
	jump_points.points[jump_points.points.size()-1] = jump_points.points[0] + direction * 64

func picked_up() -> void:
	queue_free()
