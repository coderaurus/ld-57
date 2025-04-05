extends Node2D
class_name Buckets

const BUCKET_SPRITE = preload("res://scenes/bucket_sprite.tscn")

func has_buckets() -> bool:
	return get_child_count() > 0

func add_bucket() -> void:
	var new_pos: Vector2
	var new_rotation
	if get_child_count() > 1:
		var latest_bucket:Sprite2D = get_child(get_child_count()-1)
		new_rotation = latest_bucket.rotation
		new_pos = latest_bucket.position
	var new_b = BUCKET_SPRITE.instantiate()
	add_child(new_b)
	new_b.rotation = new_rotation if new_rotation else deg_to_rad(-25)
	new_b.position = new_pos + Vector2.UP.rotated(new_b.rotation) * 12
	

func remove_bucket() -> void:
	var last_bucket = get_child(get_child_count()-1)
	last_bucket.queue_free()
