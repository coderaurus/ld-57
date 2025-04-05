extends State
class_name PlayerStateAimItem

var player: Player

func enter(parameters = []):
	if player == null: 
		player = get_parent().get_parent()
	await get_tree().process_frame
	if player.buckets.has_buckets():
		player.aim_item(on_aim_result)
	else:
		transitioned.emit(self, "idle")

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func on_aim_result(is_ok: bool, placement:Vector2, direction: Vector2) -> void:
	if is_ok:
		transitioned.emit(self, "placeitem", [placement, direction])
	else:
		transitioned.emit(self, "idle")
