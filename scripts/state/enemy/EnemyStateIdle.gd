extends State
class_name EnemyStateIdle

func enter(parameters = []):
	$Timer.start(randi_range(1,3))

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func _on_timer_timeout() -> void:
	transitioned.emit(self, "move", [])
