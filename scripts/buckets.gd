extends Node2D
class_name Buckets

const BUCKET_SPRITE = preload("res://scenes/bucket_sprite.tscn")

var stack_direction: Vector2
var stack_distance := 2

func _ready() -> void:
	if has_buckets():
		var b: Sprite2D = get_child(0)
		#stack_direction = global_position.direction_to(b.global_position).normalized()
		#stack_distance = global_position.distance_to(b.global_position)

func has_buckets() -> bool:
	return get_child_count() > 0

func add_bucket() -> void:
	var new_pos: Vector2 = Vector2(-8,-8) + Vector2(-1,-1) * stack_distance * (get_child_count()+1)
	var new_b = BUCKET_SPRITE.instantiate()
	add_child(new_b)
	#new_b.rotation = new_rotation if new_rotation else deg_to_rad(-25)
	new_b.position = new_pos
	

func remove_bucket() -> void:
	var last_bucket = get_child(get_child_count()-1)
	last_bucket.queue_free()
