extends State
class_name PlayerStateHurt


func enter(parameters = []):
	pass

func exit():
	pass

func update(_delta: float):
	var player: Player = get_parent().get_parent()
	player.global_position = (player.get_parent() as Level).get_spawn_point()
	player.on_map = 0
	transitioned.emit(self, "idle", [])

func physics_update(_delta: float):
	pass
