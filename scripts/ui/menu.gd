extends Control


func _ready() -> void:
	$Buttons/Sound/HBoxContainer/SoundSlider.value = db_to_linear(Sound.volume_db)
	$Buttons/Music/HBoxContainer/MusicSlider.value = db_to_linear(Music.volume_db)
	$Buttons/Start.grab_focus()

func _on_toggle_sound_pressed() -> void:
	$Buttons/Sound/HBoxContainer/ToggleSound.text = "On" if Sound.toggle() else "Off"


func _on_sound_slider_value_changed(value: float) -> void:
	Sound.on_range_changed(linear_to_db(value))


func _on_toggle_music_pressed() -> void:
	$Buttons/Music/HBoxContainer/ToggleMusic.text = "On" if Music.toggle() else "Off"


func _on_music_slider_value_changed(value: float) -> void:
	Music.on_range_change(linear_to_db(value))


func _on_help_pressed() -> void:
	$Buttons/Help.text = "Show Help?"


func _on_start_pressed() -> void:
	$Buttons/Start.text = "Resume Game"
	$Buttons/Respawn.disabled = false
	%UI.start_pressed.emit()


func _on_respawn_pressed() -> void:
	hide()
	%UI.respawn_pressed.emit()
