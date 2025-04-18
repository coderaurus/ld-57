extends State
class_name PlayerStateIdle


func enter(parameters = []):
	get_parent().animation_player.play("idle")

func exit():
	pass

func update(_delta: float):
	var move_input_x: float = Input.get_axis("move_left", "move_right")
	var move_input_y: float = Input.get_axis("move_up", "move_down")
	var move_input = Vector2(move_input_x, move_input_y)
	if move_input != Vector2.ZERO:
		transitioned.emit(self, "move")
	
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "aimjump")
	elif Input.is_action_just_pressed("use_item"):
		if get_parent().can_pickup():
			transitioned.emit(self, "pickup")
		else:
			transitioned.emit(self, "aimitem")

func physics_update(_delta: float):
	pass
