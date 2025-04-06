extends State
class_name EnemyStateDespawn


func enter(parameters = []):
	var fade: Color = Color.BLACK
	fade.a = 0.0
	var monster = get_parent().get_parent().get_parent() as Monster
	var tween = get_tree().create_tween()
	tween.tween_property(monster, "modulate", fade, 0.3)
	await tween.finished
	monster.queue_free()

func exit():
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass
