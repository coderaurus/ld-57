extends StaticBody2D
class_name Jumpable

func get_jump_path() -> PackedVector2Array:
	return $JumpPoints.points
