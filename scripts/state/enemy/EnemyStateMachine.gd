extends StateMachine
class_name EnemyStateMachine

var monster:Monster

func _ready():
	monster = get_parent().get_parent()
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state: 
		current_state.physics_update(delta)

func on_child_transition(state, new_state_name, parameters):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter(parameters)
	current_state = new_state
