extends State
class_name EnemyStateFlee

@export var speed := 160

var monster: Monster

func enter(parameters = []):
	monster = get_parent().monster
	monster.loop = false
	monster.progress_ratio = 0
	print("[%s] FLEE!" % monster.name)

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
