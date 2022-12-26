extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var player_scene
export(PackedScene) var first_scene
export(PackedScene) var second_scene
export var start_position = Vector2(250, 250)
var current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = first_scene.instance()
	add_child(current_scene)
	
	var player = player_scene.instance()
	player.position =  start_position
	current_scene.add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("change_map"):
		remove_child(current_scene)
		current_scene = second_scene.instance()
		add_child(current_scene)
	
		var player = player_scene.instance()
		player.position =  start_position
		current_scene.add_child(player)
