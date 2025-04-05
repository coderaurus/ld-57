extends StaticBody2D
class_name Jumpable

@onready var jump_points: Line2D = $JumpPoints

func get_jump_path() -> PackedVector2Array:
	return $JumpPoints.points

func set_jump_direction(direction: Vector2) -> void:
	jump_points.points[jump_points.points.size()-1] = jump_points.points[0] + direction * 80
