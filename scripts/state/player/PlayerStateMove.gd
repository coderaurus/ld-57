extends State
class_name PlayerStateMove

@export var speed := 140

var player:Player

func enter(parameters = []):
	if player == null:
		player = get_parent().get_parent()
	player.animation_player.play("run")
	player.get_node("Dust").emitting = true

func exit():
	player.animation_player.stop()
	player.get_node("Dust").emitting = false

func update(_delta: float):
	var move_input_x: float = Input.get_axis("move_left", "move_right")
	var move_input_y: float = Input.get_axis("move_up", "move_down")
	var move_input = Vector2(move_input_x, move_input_y)
	
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "aimjump")
	elif Input.is_action_just_pressed("use_item"):
		if get_parent().can_pickup():
			transitioned.emit(self, "pickup")
		else:
			transitioned.emit(self, "aimitem")
	elif move_input == Vector2.ZERO:
		transitioned.emit(self, "idle")
	else:
		var boost := 1.5 if Input.is_action_pressed("move_boost") else 1.0
		player.facing = move_input
		player.velocity = move_input.normalized() * speed * boost
		player.move_and_slide()

func physics_update(_delta: float):
	pass
