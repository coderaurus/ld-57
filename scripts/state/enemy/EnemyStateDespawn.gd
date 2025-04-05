extends State
class_name EnemyStateDespawn


func enter(parameters = []):
	get_parent().monster.queue_free()

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
