extends State
class_name EnemyStateFlee

@export var speed := 160

var monster: Monster

func enter(parameters = []):
	monster = get_parent().monster
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
	var tween = get_tree().create_tween()
	tween.tween_property(visage, "global_position", visage.global_position + Vector2.UP * 12, 0.5)
	tween.parallel().tween_property(visage, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN)
