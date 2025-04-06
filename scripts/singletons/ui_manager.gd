extends CanvasLayer
class_name UIManager

signal start_pressed
signal pause_pressed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_pressed.emit()

func hide_menu() -> void:
	$Menu.hide()

func show_menu() -> void:
	$Menu.show()
