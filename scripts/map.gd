extends Node2D
class_name Map

var ground: TileMapLayer
var wall: TileMapLayer
var objects: Node2D

func _ready() -> void:
	ground = get_node_or_null("Ground")
	wall = get_node_or_null("Wall")
	objects = get_node_or_null("Objects")


func is_position_empty(pos: Vector2, facing: Vector2i) -> Vector2:
	var local_pos = to_local(pos)
	var ground_dual: TileMapDual = ground.get_child(0)
	var coord = ground.local_to_map(local_pos)
	var player_tile = ground.get_cell_atlas_coords(coord)
	coord += facing * 2 if player_tile != Vector2i(2,1) else facing * 1
	var tile = ground.get_cell_atlas_coords(coord)
	var is_empty_tile = tile == ground_dual.empty_tile
	var is_invalid_tile = tile == Vector2i(-1, -1)
	var is_empty = is_empty_tile or is_invalid_tile
	if not is_empty:
		print("[%s] Position not empty" % [self.name])
		return Vector2(-1, -1)
		print("[%s] Is %s at [C:%s | P:%s | F:%s | T:%s] empty? %s " % [self.name, tile, coord, pos, facing, player_tile, is_empty])
	else:
		var adjusted_position = ground.map_to_local(coord)
		if facing.x == 0:
			adjusted_position.x = pos.x
		
		print("[%s] Position empty" % self.name)
		return adjusted_position


func has_jumpable_object_at(pos: Vector2, facing: Vector2i) -> Array[Vector2]:
	if objects == null or objects.get_child_count() == 0:
		print("[%s] No objects" % self.name)
		return []
	print("[%s] Objects: %s" % [self.name, objects.get_child_count()])
	var ground_dual: TileMapDual = ground.get_node("TileMapDual")
	for c:Node2D in objects.get_children():
		var jump_coord = ground_dual.local_to_map(pos) + facing
		var c_coord = ground_dual.local_to_map(c.global_position)
		if c_coord.distance_to(jump_coord) <= 1 and c is Jumpable:
			print("[%s] Object found: %s" % [self.name, c.name])
			var arr: Array[Vector2] = []
			for v in c.get_jump_path():
				arr.append(c.to_global(v))
			return arr
		
	print("[%s] None were jumpable" % [self.name])
	return []
	
