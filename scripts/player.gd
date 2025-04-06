extends CharacterBody2D
class_name Player

@onready var buckets: Buckets = $Sprite2D/Buckets

var facing: Vector2
var on_map: int = 0
var is_ascending := false
var landing_position: Vector2
var toy_acquired := false
var spawn_point: Vector2

signal is_aiming_jump
signal is_aiming_item
signal is_placing_item
signal toy_get

func _process(delta: float) -> void:
	pass

func aim_jump(callback: Callable) -> void:
	is_aiming_jump.emit(facing, callback)

func jump(jumps: Array[Vector2], callback: Callable) -> void:
	print("Jumping ", jumps)
	print("Current pos ", global_position)
	var jump_time := 0.3
	var tween = get_tree().create_tween()
	for j in jumps:
		landing_position = j
		if not is_ascending:
			j += Vector2.UP * (8 if facing.y != -1 else 4)
			#j.x /= 2 if facing.x != 0 else 1
			print("J ", j)
		tween.tween_property(self, "global_position:x", j.x, jump_time).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property(self, "global_position:y", j.y, jump_time).set_trans(Tween.TRANS_CIRC)
	
	tween.tween_callback(callback)

func land(callback: Callable) -> void:
	if is_ascending:
		callback.call()
	else:
		var land_time := 0.5
		var tween = get_tree().create_tween()
		var landing_distance = 40 if facing != Vector2.UP else 4
		tween.tween_property(self, "global_position:x", landing_position.x, land_time).set_trans(Tween.TRANS_CIRC)
		tween.parallel().tween_property(self, "global_position:y", landing_position.y + landing_distance, land_time).set_trans(Tween.TRANS_CIRC)
		tween.tween_callback(callback)


func aim_item(callback: Callable) -> void:
	is_aiming_item.emit(callback)

func place_item(placement: Vector2, direction: Vector2) -> void:
	buckets.remove_bucket()
	is_placing_item.emit(placement, direction)

func get_toy() -> void:
	toy_acquired = true
	toy_get.emit()
	$Sprite2D/ToySprite.show()
	$Bravery.set_deferred("monitorable" , true)
	$Bravery.monitoring = true

func get_pickup() -> void:
	buckets.add_bucket()


func hurt() -> void:
	print("ouch")
	$StateMachine.transition_to("hurt")
	
func reset() -> void:
	global_position = spawn_point
	on_map = 0

func _on_bravery_area_entered(area: Area2D) -> void:
	if toy_acquired and area.get_parent() is Monster:
		(area.get_parent() as Monster).flee(global_position)
	elif toy_acquired and area is Horror:
		(area as Horror).discover()
