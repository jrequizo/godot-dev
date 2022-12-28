class_name Teleport
extends Node


var player: Player

var can_teleport = true

onready var delay_timer = get_node("DelayTimer")


func _ready():
	yield(owner, "ready")
	
	player = owner as Player
	
	assert(player != null)


func _process(delta):
	if (
		Input.is_action_pressed("spacebar") and
		can_teleport and 
		player.is_on_floor() and 
		player.movement_direction_x != 0
	):
		can_teleport = false
		
		var new_position = Vector2(
			player.position.x + player.movement_direction_x * 200, 
			player.position.y
		)
		
		player.position = new_position
		
		delay_timer.start(0.5)
		

func _on_DelayTimer_timeout():
	can_teleport = true
