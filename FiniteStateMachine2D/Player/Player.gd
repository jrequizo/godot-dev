class_name Player
extends KinematicBody2D

var velocity = Vector2.ZERO

var movement_direction_x = 0

export var MOVEMENT_SPEED = 125 * 1.4
export var JUMP_SPEED = 555

export var MAX_FALL_SPEED = 670
export var GRAVITY_ACCELERATION = 2000

export var DRAG = 25.0
export var MAX_FRICTION = 2
export var MIN_FRICTION = 0.05

export var MOVEMENT_THRESHOLD = 0.8


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
