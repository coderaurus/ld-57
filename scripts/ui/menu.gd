extends Control


func _ready() -> void:
	$HBoxContainer/Sound/HBoxContainer/SoundSlider.value = db_to_linear(Sound.volume_db)
	$HBoxContainer/Music/HBoxContainer/MusicSlider.value = db_to_linear(Music.volume_db)

func _on_toggle_sound_pressed() -> void:
	$HBoxContainer/Sound/HBoxContainer/ToggleSound.text = "On" if Sound.toggle() else "Off"


func _on_sound_slider_value_changed(value: float) -> void:
	Sound.on_range_changed(linear_to_db(value))


func _on_toggle_music_pressed() -> void:
	$HBoxContainer/Music/HBoxContainer/ToggleMusic.text = "On" if Music.toggle() else "Off"


func _on_music_slider_value_changed(value: float) -> void:
	Music.on_range_change(linear_to_db(value))
	
