extends State
class_name PlayerStateMove

@export var speed := 200

var player:CharacterBody2D

func enter():
	if player == null:
		player = get_parent().get_parent()

func exit():
	pass

func update(_delta: float):
	var move_input_x: float = Input.get_axis("move_left", "move_right")
	var move_input_y: float = Input.get_axis("move_up", "move_down")
	var move_input = Vector2(move_input_x, move_input_y)
	
	if move_input == Vector2.ZERO:
		transitioned.emit(self, "idle")
	else:
		var boost := 2 if Input.is_action_pressed("move_boost") else 1
		player.velocity = move_input * speed * boost
		player.move_and_slide()

func physics_update(_delta: float):
	pass
