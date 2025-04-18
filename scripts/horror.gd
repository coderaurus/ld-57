extends Area2D
class_name Horror

var identity_discovered = false


func _ready() -> void:
	scale.x *= 1 if randf() < 0.6 else -1
	await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
	$AnimationPlayer.play("idle")

func discover() -> void:
	if not identity_discovered:
		print("Discovered horror")
		identity_discovered = true
		$AnimationPlayer.stop()
		$AnimationPlayer.play("discover")
		Sound.sound("discover")
		($CollisionShape2D.shape as CircleShape2D).radius = 24 # 32 original


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if not identity_discovered:
			body.hurt()
		else:
			if $AnimationPlayer.current_animation != "discover":
				$AnimationPlayer.play("sway")


func _on_body_exited(body: Node2D) -> void:
	pass
	#if body is Player and not identity_discovered:
		#$AnimationPlayer.play("idle")
