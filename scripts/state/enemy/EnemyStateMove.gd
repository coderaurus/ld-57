extends State
class_name EnemyStateMove

@export var speed := 140

var monster: Monster

func enter(parameters = []):
	monster = get_parent().monster
	$Timer.start(randi_range(8,10))

func exit():
	$Timer.stop()

func update(_delta: float):
	var current_pos = monster.global_position
	monster.progress = monster.progress + speed * _delta
	var next_pos = monster.global_position
	var x_delta = next_pos.x - current_pos.x
	if x_delta > 0 and monster.scale.x != 1:
		monster.scale.x = 1
	elif x_delta < 0 and monster.scale.x != -1:
		monster.scale.x = -1
	
	if monster.progress_ratio == 1.0 and not monster.loop:
		monster.flip_trail()
		transitioned.emit(self, "idle", [])


func physics_update(_delta: float):
	pass


func _on_timer_timeout() -> void:
	print("[%s] STOP (timeout)" % monster.name)
	transitioned.emit(self, "idle", [])
