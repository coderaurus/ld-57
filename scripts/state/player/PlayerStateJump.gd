extends State
class_name PlayerStateJump

var player: Player

func enter(parameters = []):
	if player == null: 
		player = get_parent().get_parent()
	player.animation_player.play("jump")
	player.jump(parameters, on_jumped)

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func on_jumped() -> void:
	transitioned.emit(self, "land")
