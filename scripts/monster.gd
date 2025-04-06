extends PathFollow2D
class_name Monster

var trail: MonsterTrail
var identity_discovered := false

func _ready() -> void:
	trail = get_parent()
	loop = trail.loops

func flip_trail() -> void:
	var path = trail.curve.get_baked_points()
	var new_curve=Curve2D.new()
	for i in range(trail.curve.point_count-1,-1,-1):
		new_curve.add_point(trail.curve.get_point_position(i))
	trail.curve=new_curve
	progress_ratio = 0.0

func flee(from: Vector2) -> void:
	if $Area2D/StateMachine.current_state is EnemyStateFlee or identity_discovered:
		return
	
	identity_discovered = true
	var new_curve=Curve2D.new()
	var direction = from.direction_to(global_position).normalized()
	var local_start = trail.to_local(global_position)
	new_curve.add_point(local_start)
	new_curve.add_point(local_start + direction * 96)
	trail.curve=new_curve
	progress_ratio = 0
	$Area2D/StateMachine.transition_to("flee", [])

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not identity_discovered:
		body.hurt()
