extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var offset = Vector2(5, 5)
onready var player
onready var tilemap

var count = 0

var tile_array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
	# Generate randomizer using a seed
	seed(123)
	player = get_node("Player")
	tilemap = get_node("TileMap")
	initialize_tileset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	count += 1
	
	if (count % 12 == 0):
		generate_tiles()
		count = 0

func initialize_tileset():
	# Generate the tiles to use for procedural generation
	var tiles = tilemap.tile_set
	var rect = tiles.tile_get_region(0)

	var size_x = rect.size.x / tiles.autotile_get_size(0).x
	var size_y = rect.size.y / tiles.autotile_get_size(0).y
	
	for x in range(size_x):
		for y in range(size_y):
			var priority = tiles.autotile_get_subtile_priority(0, Vector2(x, y))
			print(priority)
			for p in priority:
				tile_array.append(Vector2(x, y))
	
func generate_tiles():	
	# Retrieve player position
	var player_position = tilemap.world_to_map(player.position)
	
	var bounds = get_player_boundaries(player.position)
	var min_bounds = tilemap.world_to_map(bounds["minimum"]) - offset
	var max_bounds = tilemap.world_to_map(bounds["maximum"]) + offset
	
	for _x in range(min_bounds.x, max_bounds.x):
		for _y in range(min_bounds.y, max_bounds.y):
			# Generate new tile at player location
			var pos = Vector2(_x, _y)
			var current_tile = tilemap.get_cellv(pos)

			if (current_tile == -1):
				tilemap.set_cellv(pos, 0, false, false, false, tile_array[randi() % tile_array.size()])
	
	
func get_player_boundaries(position: Vector2):
	var boundaries = get_viewport().size / 2
	
	var min_x = player.position.x - boundaries.x
	var min_y = player.position.y - boundaries.y
	
	var max_x = player.position.x + boundaries.x
	var max_y = player.position.y + boundaries.y
	
	var min_bounds = Vector2(min_x, min_y)
	var max_bounds = Vector2(max_x, max_y)
	
	return {
		"minimum": min_bounds,
		"maximum": max_bounds
	}
