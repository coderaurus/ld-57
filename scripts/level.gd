extends Node2D
class_name Level

@onready var player := $Player
@onready var maps: Node2D = $Maps


func _ready() -> void:
	player.is_aiming_jump.connect(_on_player_aiming_jump)

func _on_player_aiming_jump(direction:Vector2, callback: Callable) -> void:
	var map: Map = maps.get_child(player.on_map)
	if map.is_position_empty(player.global_position, direction):
		callback.call(true)
	else:
		callback.call(false)
