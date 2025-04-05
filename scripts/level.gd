extends Node2D
class_name Level

@onready var player := $Player
@onready var maps: Node2D = $Maps


func _ready() -> void:
	player.is_aiming_jump.connect(_on_player_aiming_jump)

func _on_player_aiming_jump(direction:Vector2, callback: Callable) -> void:
	var map: Map = maps.get_child(player.on_map)
	if map == null:
		callback.call(false, [] as Array[Vector2])
	
	var landing_position = map.is_position_empty(player.global_position, direction)
	# Empty position => get coordinate
	if landing_position != Vector2(-1, -1):
		print("Normal jump")
		player.is_ascending = false
		callback.call(true, [landing_position] as Array[Vector2])
		player.on_map += 1
	else:
		# Search for jumpable objects to get up
		var jumpable_path: Array[Vector2] = map.has_jumpable_object_at(player.global_position, direction)
		if jumpable_path.size() > 0:
			print("Jumpable: ", jumpable_path)
			player.is_ascending = true
			callback.call(true, jumpable_path)
			player.on_map -= 1
		else:
			print("No jump")
			callback.call(false, [] as Array[Vector2])
