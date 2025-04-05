extends CharacterBody2D
class_name Player

var facing: Vector2
var on_map: int = 0

signal is_aiming_jump

func _process(delta: float) -> void:
	pass

func aim_jump(callback: Callable) -> void:
	is_aiming_jump.emit(facing, callback)

func jump(callback: Callable) -> void:
	var jump_time := 0.3
	var jump_position: Vector2 = global_position
	jump_position += Vector2.UP * 8
	jump_position += facing * (16 if facing.x == 0 else 32)
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position:x", jump_position.x, jump_time).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "global_position:y", jump_position.y, jump_time).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(callback)

func land(callback: Callable) -> void:
	var land_time := 0.5
	var land_position: Vector2 = global_position
	land_position += Vector2.DOWN * 40
	land_position += facing * (16 if facing.x == 0 else 32)
	
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position:x", land_position.x, land_time).set_trans(Tween.TRANS_CIRC)
	tween.parallel().tween_property(self, "global_position:y", land_position.y, land_time).set_trans(Tween.TRANS_CIRC)
	tween.tween_callback(callback)
