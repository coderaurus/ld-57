extends Node2D
class_name Map


const MONSTER = preload("res://scenes/monster.tscn")

var map_above: Map
var map_below: Map

var ground: TileMapLayer
var ground_dual: TileMapDual
var wall: TileMapLayer
var wall_dual: TileMapDual
var objects: Node2D
var trails: Node2D

func _ready() -> void:
	ground = get_node_or_null("Ground")
	ground_dual = get_node_or_null("GroundDual")
	if ground_dual == null:
		ground_dual = ground.get_child(0)
	wall = get_node_or_null("Wall")
	wall_dual = get_node_or_null("WallDual")
	if wall_dual == null:
		wall_dual = wall.get_child(0)
	
	ground.enabled = false
	wall.enabled = false
		
	objects = get_node_or_null("Objects")
	trails = get_node_or_null("Trails")
	_fill_trails()
	

func is_position_available(pos: Vector2, facing: Vector2i) -> Vector2:
	var pos_coord = ground.local_to_map(to_local(pos))+facing
	var checked_position = is_position_fillable(pos, facing)
	if checked_position != Vector2(-1,-1):
		for obj:Node2D in objects.get_children():
			var obj_coord = ground.local_to_map(to_local(obj.global_position))
			if pos_coord.distance_to(obj_coord) < 1:
				return Vector2(-1,-1)
		return to_global(ground.map_to_local(pos_coord))
	return Vector2(-1,-1)

func is_position_fillable(pos: Vector2, facing: Vector2i) -> Vector2:
	var local_pos = to_local(pos)
	var coord = ground.local_to_map(local_pos)
	var player_tile = ground.get_cell_atlas_coords(coord)
	coord += facing
	var tile = ground.get_cell_atlas_coords(coord)
	var is_valid_tile = tile == ground_dual.full_tile
	if is_valid_tile:
		return ground.map_to_local(coord)
	else:
		return Vector2(-1, -1)

func is_position_empty(pos: Vector2, facing: Vector2i) -> Vector2:
	var local_pos = to_local(pos)
	var coord = ground.local_to_map(local_pos)
	var player_tile = ground.get_cell_atlas_coords(coord)
	coord += facing
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
		#print("[%s] No objects" % self.name)
		return []
	#print("[%s] Objects: %s" % [self.name, objects.get_child_count()])
	for c:Node2D in objects.get_children():
		var jump_coord = ground_dual.local_to_map(pos) + facing
		var c_coord = ground_dual.local_to_map(c.global_position)
		# Only PLACED jumpables are valid
		if c_coord.distance_to(jump_coord) <= 1 \
		and c is Jumpable and (c as Jumpable).is_jumpable:
			#print("[%s] Object found: %s" % [self.name, c.name])
			var arr: Array[Vector2] = []
			for v in c.get_jump_path():
				arr.append(c.to_global(v))
			return arr
		
	#print("[%s] None were jumpable" % [self.name])
	return []
	
func initialize_objects() -> void:
	for obj in objects.get_children():
		var obj_coord = ground.local_to_map(to_local(obj.global_position))
		obj.global_position = to_global(ground.map_to_local(obj_coord))
		if obj is Jumpable:
			var jump_path = obj.get_jump_path()
			var jump_end_point = jump_path[jump_path.size()-1]
			if obj.is_jumpable:
				if map_above == null:
					print("Freeing %s, no map to jump to" % obj.name)
					obj.call_deferred("queue_free")
				else:
					jump_end_point = map_above.get_landing_tile(jump_end_point)
					jump_path[jump_path.size()-1] = jump_end_point
					obj.jump_points.points = jump_path


func get_landing_tile(landing_pos: Vector2) -> Vector2:
	var coord = ground_dual.local_to_map(to_local(landing_pos))
	return ground_dual.map_to_local(to_global(coord))

func _fill_trails() -> void:
	for trail: Path2D in trails.get_children():
		if trail.get_child_count() == 0:
			var m = MONSTER.instantiate()
			trail.add_child(m)
			m.progress_ratio = randf()

func show_me(transparency: float = 1.0, is_instant := false) -> void:
	print("[%s] Showing %s | %s" % [self.name, transparency, is_instant])
	visible = true
	var c: Color = Color.WHITE
	if transparency < 1.0:
		c = c.darkened(1-transparency)
		c = c.blend(Color.SLATE_GRAY)
		_disable_layer_collisions()
	else:
		_enable_layer_collisions()
	c.a = transparency
	
	
	if is_instant:
		modulate = c
	else:
		var fade_time := 1.0
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", c, fade_time)

func hide_me(transparency := 0.0, is_instant := false) -> void:
	print("[%s] Hiding %s | %s" % [self.name, transparency, is_instant])
	_disable_layer_collisions()
	if not visible and transparency > 0.0:
		visible = true
	var c:Color = Color.BLACK if transparency < 0.5 else Color.DIM_GRAY
	c = c.blend(Color.DARK_BLUE)
	c.a = transparency
	
	if is_instant:
		modulate = c
		if transparency == 0.0:
			visible = false
	else:
		var fade_time := 1.0
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", c, fade_time)
		if transparency == 0.0:
			tween.tween_property(self, "visible", false, 0.0)

func _enable_layer_collisions() -> void:
	ground_dual.collision_enabled = true
	wall_dual.collision_enabled = true

func _disable_layer_collisions() -> void:
	ground_dual.collision_enabled = false
	wall_dual.collision_enabled = false
