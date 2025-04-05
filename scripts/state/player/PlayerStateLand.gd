extends State
class_name PlayerStateLand

var player: Player

func enter():
	if player == null: 
		player = get_parent().get_parent()
	player.land(on_landed)

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func on_landed() -> void:
	transitioned.emit(self, "idle")
