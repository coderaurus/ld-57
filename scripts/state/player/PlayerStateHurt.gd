extends State
class_name PlayerStateHurt


func enter(parameters = []):
	pass

func exit():
	pass

func update(_delta: float):
	var player: Player = get_parent().get_parent()
	player.animation_player.play("hurt")
	await player.animation_player.animation_finished
	player.reset()
	transitioned.emit(self, "idle", [])

func physics_update(_delta: float):
	pass
