extends Node2D
class_name Map

var ground: TileMapLayer
var wall: TileMapLayer

func _ready() -> void:
	ground = get_node_or_null("Ground")
	wall = get_node_or_null("Wall")


func is_position_empty(pos: Vector2, facing: Vector2i) -> bool:
	var local_pos = to_local(pos)
	var ground_dual: TileMapDual = ground.get_child(0)
	var coord = ground.local_to_map(local_pos)
	var player_tile = ground.get_cell_atlas_coords(coord)
	coord += facing * 2 if player_tile != ground_dual.full_tile else facing * 1
	var tile = ground.get_cell_atlas_coords(coord)
	var is_empty_tile = tile == ground_dual.empty_tile
	var is_invalid_tile = tile == Vector2i(-1, -1)
	var is_empty = is_empty_tile or is_invalid_tile
	if not is_empty:
		print("[%s] Is %s at [C:%s | P:%s | F:%s | T:%s] empty? %s " % [self.name, tile, coord, pos, facing, player_tile, is_empty])
	
	return is_empty
