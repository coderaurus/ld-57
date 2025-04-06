extends CanvasLayer
class_name UIManager

signal start_pressed
signal pause_pressed
signal respawn_pressed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_pressed.emit()

func hide_menu() -> void:
	$Menu.hide()

func show_menu() -> void:
	$Menu.show()
	$Menu/Buttons/Start.grab_focus()

func show_game_end() -> void:
	$GameEnd.show()
	$GameEnd/Control/PlayAgain.grab_focus()

func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
