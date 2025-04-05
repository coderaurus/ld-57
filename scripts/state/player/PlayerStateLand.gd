extends State
class_name PlayerStateLand

var player: Player
var is_landing = false

func enter(parameters = []):
	if player == null: 
		player = get_parent().get_parent()

func exit():
	is_landing = false

func update(_delta: float):
	if not is_landing:
		is_landing = true
		player.land(on_landed)

func physics_update(_delta: float):
	pass

func on_landed() -> void:
	print("Landed")
	player.is_ascending = false # default back to going down
	transitioned.emit(self, "idle")
