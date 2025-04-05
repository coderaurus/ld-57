extends State
class_name PlayerStateAimJump

var player: Player

func enter():
	if player == null: 
		player = get_parent().get_parent()
	await get_tree().process_frame
	player.aim_jump(on_aim_result)

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func on_aim_result(is_ok: bool) -> void:
	if is_ok:
		transitioned.emit(self, "jump")
	else:
		transitioned.emit(self, "idle")
