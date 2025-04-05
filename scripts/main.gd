extends Node2D
class_name Main

@onready var camera: Camera2D = $Level/Camera2D
@onready var map: Node2D = $Level/Maps/Map

func _ready() -> void:
	var ground: TileMapLayer = map.get_node("Ground")
	
	camera.limit_right = ground.get_used_rect().size.x * ground.tile_set.tile_size.x - 64
	camera.limit_bottom = ground.get_used_rect().size.y * ground.tile_set.tile_size.y - 64

func on_goal_reached() -> void:
	print("Game won! (game paused)")
	get_tree().paused = true
