extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var player_scene
export (PackedScene) var start_scene

onready var current_scene
onready var player_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("player_entered_portal", self, "_player_entered_portal")
	
	# Load in the start scene
	var start_scene_instance = start_scene.instance()
	self.add_child(start_scene_instance)
	
	var player_instance = player_scene.instance()
	start_scene_instance.add_child(player_instance)
	
	current_scene = start_scene_instance


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _player_entered_portal(portal):
	# Change the scenes to the portal target
	current_scene.remove_child(player_instance)
	remove_child(current_scene)
	
	current_scene = load(portal.target_scene).instance()
	add_child(current_scene)
	
	var player_instance = player_scene.instance()
	current_scene.add_child(player_instance)
