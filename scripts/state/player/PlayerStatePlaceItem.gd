extends State
class_name PlayerStatePlaceItem

var player: Player

func enter(parameters = []):
	if player == null: 
		player = get_parent().get_parent()
	player.place_item(parameters[0], parameters[1])
	player.animation_player.play("use_item")
	Sound.sound("item")

func exit():
	if player.animation_player.is_playing():
		await player.animation_player.animation_finished

func update(_delta: float):
	transitioned.emit(self, "idle", [])

func physics_update(_delta: float):
	pass
