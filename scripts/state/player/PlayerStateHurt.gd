extends State
class_name PlayerStateHurt

var player: Player

func enter(parameters = []):
	Sound.sound("hurt")
	player = get_parent().get_parent()
	player.animation_player.play("hurt")
	await player.animation_player.animation_finished
	player.reset()
	transitioned.emit(self, "idle", [])

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
