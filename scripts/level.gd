extends Node2D
class_name Level

@onready var player : Player
@onready var maps: Node2D = $Maps

const PLAYER = preload("res://scenes/player.tscn")
const BUCKET = preload("res://scenes/bucket.tscn")
const TOY = preload("res://scenes/toy.tscn")
const GOAL = preload("res://scenes/goal.tscn")

var goal: Goal

func _ready() -> void:
	_spawn_player()
	
	var ground: TileMapLayer = (maps.get_child(0) as Map).ground
	$Camera2D.limit_left = ground.get_used_rect().position.x * ground.tile_set.tile_size.x
	$Camera2D.limit_top = ground.get_used_rect().position.y * ground.tile_set.tile_size.y
	$Camera2D.limit_right = $Camera2D.limit_left + ground.get_used_rect().size.x * ground.tile_set.tile_size.x
	$Camera2D.limit_bottom = $Camera2D.limit_top + ground.get_used_rect().size.y  * ground.tile_set.tile_size.y
	
	var map_count = maps.get_child_count()
	for i in map_count:
		# Note: there is always more than one map layer
		if i == 0: 
			(maps.get_child(i) as Map).map_below = maps.get_child(i+1)
		elif i == map_count - 1:
			(maps.get_child(i) as Map).map_above = maps.get_child(i-1)
		else:
			(maps.get_child(i) as Map).map_above = maps.get_child(i-1)
			(maps.get_child(i) as Map).map_below = maps.get_child(i+1)
	_initialize()

func _initialize() -> void:
	for m:Map in maps.get_children():
		m.initialize_objects()
	
	_place_toy()

func _on_player_aiming_jump(direction:Vector2, callback: Callable) -> void:
	var map: Map = maps.get_child(player.on_map)
	if map == null:
		callback.call(false, [] as Array[Vector2])
	
	var landing_position = map.is_position_empty(player.global_position, direction)
	if map.map_below != null:
		landing_position = map.map_below.is_position_fillable(player.global_position, direction)
	else:
		landing_position = Vector2(-1, -1)
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


func _on_player_aiming_item(callback: Callable) -> void:
	var map: Map = maps.get_child(player.on_map)
	if map.map_above == null:
		callback.call(false, Vector2(-1, -1), Vector2(-1, -1))
		return
		
	var aimed_position = map.is_position_available(player.global_position, player.facing)
	if aimed_position != Vector2(-1, -1):
		var directions = [
			Vector2.UP,
			Vector2.RIGHT,
			Vector2.DOWN,
			Vector2.LEFT
		]
		
		for d in directions:
			var item_direction = map.map_above.is_position_available(aimed_position, d)
			if item_direction != Vector2(-1,-1):
				print("Item %s can can be directed to %s " % [aimed_position, item_direction])
				print("Distance: %s" % aimed_position.distance_to(item_direction))
				callback.call(true, aimed_position, d)
				return
		callback.call(false, Vector2(-1, -1), Vector2(-1, -1))
		return
	callback.call(false, Vector2(-1, -1), Vector2(-1, -1))

func _on_player_placing_item(placement:Vector2, direction:Vector2) -> void:
	var bucket = BUCKET.instantiate()
	(maps.get_child(player.on_map) as Map).objects.add_child(bucket)
	bucket.global_position = placement
	bucket.set_jump_direction(direction)

func _place_toy() -> void: 
	var last_map: Map = maps.get_child(maps.get_child_count()-1)
	var ground_rect = last_map.ground.get_used_rect()
	var spawn_point = ground_rect.size / 2
	var spawn_position = ground_rect.position
	spawn_point.x = randf_range(spawn_position.x + spawn_point.x - 2, spawn_position.x + spawn_point.x + 2)
	spawn_point.x = clampi(spawn_position.x + spawn_point.x, spawn_position.x + 2, spawn_position.x + ground_rect.size.x - 2)
	spawn_point.y = randf_range(spawn_position.y + spawn_point.y - 2, spawn_position.y + spawn_point.y + 2)
	spawn_point.y = clampi(spawn_position.y + spawn_point.y,spawn_position.y +  2, spawn_position.y + ground_rect.size.y - 2)
	
	var toy = TOY.instantiate()
	last_map.objects.add_child(toy)
	toy.global_position = spawn_point * 64

func _spawn_player() -> void:
	player = PLAYER.instantiate()
	add_child(player)
	player.global_position = get_spawn_point()
	player.spawn_point = player.global_position
	player.is_aiming_jump.connect(_on_player_aiming_jump)
	player.is_aiming_item.connect(_on_player_aiming_item)
	player.is_placing_item.connect(_on_player_placing_item)
	player.toy_get.connect(_on_player_toy_get)
	
	$Camera2D.target = player

func _spawn_goal() -> void:
	goal = GOAL.instantiate()
	add_child(goal)
	goal.global_position = get_spawn_point()
	goal.goal_reached.connect(get_parent().on_goal_reached)
	

func get_spawn_point() -> Vector2:
	$Spawn/Point.progress_ratio = randf()
	return $Spawn/Point.global_position

func _on_player_toy_get() -> void:
	call_deferred("_spawn_goal")
