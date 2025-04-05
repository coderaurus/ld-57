extends StateMachine
class_name PlayerStateMachine

@export var is_debugging := false

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
		else:
			printerr("%s is not a State" % child.name)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state: 
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name, parameters = []):
	if is_debugging: 
		print("%s wants to %s" % [state.name, new_state_name])
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	if is_debugging: 
		print("Entering %s" % new_state.name)
	new_state.enter(parameters)
	current_state = new_state

func can_pickup() -> bool:
	return (get_node("Pickup") as PlayerStatePickup).can_pickup()
