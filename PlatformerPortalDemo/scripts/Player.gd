extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var jumpSpeed = 555 * 1.12
export var walkSpeed = 125 * 1.4
export var MAX_FALL_SPEED = 670
export var GRAVITY_ACCELERATION = 2000

export var drag = 1.0
export var maxFriction = 2
export var minFriction = 0.05

export var movementThreshold = 0.02

var velocity = Vector2()
var hasFoothold = true

var direction = null
var hasMovedInAir = false

var floatCoefficient = 0.01

var floatDrag2 = 10000;
var mass = 100;

var current_portal = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta):
	direction = null
	if is_on_floor():
		velocity.y = 0
	
		if Input.is_action_pressed("move_left"):
			velocity.x -= walkSpeed * 2
		elif Input.is_action_just_released("move_left"):
			direction = null
		if Input.is_action_pressed("move_right"):
			velocity.x += walkSpeed * 2
		elif Input.is_action_just_released("move_right"):
			direction = null
		if Input.is_action_pressed("move_jump"):
			velocity.y -= jumpSpeed 
	else:
		pass
			
		
	if (is_on_ceiling()):
		velocity.y = 0
	
	drag = clamp(drag, minFriction, maxFriction)
	if (drag < 1):
		drag *= 0.5
		
	if (velocity.x > movementThreshold):
		direction = 1
	elif (velocity.x < -movementThreshold):
		direction = -1
	
	velocity.y += delta * GRAVITY_ACCELERATION
	velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)
	
	move_and_slide(velocity, Vector2.UP)
	
	if (is_on_floor() && direction):
		# Do friction properly!!! code below automatically sets to 0
		if (direction == 1):
			velocity.x = min(0, velocity.x - drag * delta)
		elif (direction == -1):
			velocity.x = max(0, velocity.x + drag * delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("move_up") and current_portal:
		Events.emit_signal("player_entered_portal", current_portal)
