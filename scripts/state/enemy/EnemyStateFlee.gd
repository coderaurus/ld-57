extends State
class_name EnemyStateFlee

@export var speed := 160

var monster: Monster

func enter(parameters = []):
	monster = get_parent().monster
	(monster.get_node("Area2D") as Area2D).set_deferred("monitorable", false)
	(monster.get_node("Area2D") as Area2D).set_deferred("monitoring", false)
	monster.loop = false
	monster.progress_ratio = 0
	print("[%s] FLEE!" % monster.name)
	_shed_visage()

func exit():
	pass

func update(_delta: float):
	var current_pos = monster.global_position
	monster.progress = monster.progress + speed * _delta
	var next_pos = monster.global_position
	var x_delta = next_pos.x - current_pos.x
	if x_delta > 0 and monster.scale.x != 1:
		monster.scale.x = 1
	elif x_delta < 0 and monster.scale.x != -1:
		monster.scale.x = -1
		
	if monster.progress_ratio == 1.0:
		_on_fled()

func physics_update(_delta: float):
	pass

func _on_fled() -> void:
	print("[%s] FLED!" % monster.name)
	transitioned.emit(self, "despawn", [])

func _shed_visage() -> void:
	var visage: Sprite2D = monster.get_node("Area2D/Visage")
	var true_visage: Sprite2D = monster.get_node("Area2D/TrueVisage")
	true_visage.show()
	visage.top_level = true
	visage.global_position = global_position
	visage.rotation = 0
	visage.reparent(monster.get_parent())
	var tween = get_tree().create_tween()
	tween.tween_property(visage, "position", visage.position + Vector2.UP * 24, 0.4)
	tween.parallel().tween_property(visage, "modulate", Color.TRANSPARENT, 0.4).set_ease(Tween.EASE_IN)
	Sound.sound("discover")
