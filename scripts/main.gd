extends Node2D
class_name Main

@onready var camera: Camera2D = $Level/Camera2D
@onready var map: Node2D = $Level/Maps/Map
@onready var level: Level = $Level

func _ready() -> void:
	get_tree().paused = true
	%UI.start_pressed.connect(_on_start_pressed)
	%UI.pause_pressed.connect(_on_pause_pressed)
	%UI.respawn_pressed.connect(_on_respawn_pressed)

func on_goal_reached() -> void:
	print("Game won! (game paused)")
	get_tree().paused = true
	%UI.show_game_end()


func _on_start_pressed() -> void:
	get_tree().paused = false
	%UI.hide_menu()

func _on_pause_pressed() -> void:
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		%UI.show_menu()
	else:
		%UI.hide_menu()

func _on_respawn_pressed() -> void:
	level.player.reset()
	get_tree().paused = false
