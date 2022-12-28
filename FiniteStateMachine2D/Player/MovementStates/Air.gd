extends PlayerState


# If we get a message asking us to jump, we jump.
func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.JUMP_SPEED


func physics_update(delta: float) -> void:
	# Horizontal movement.
#	var input_direction_x: float = (
#		Input.get_action_strength("move_right")
#		- Input.get_action_strength("move_left")
#	)
#	player.velocity.x = player.WALK_SPEED * input_direction_x

	# Vertical movement.
	player.velocity.y += player.GRAVITY_ACCELERATION * delta
	# Update movement.
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	# Landing.
	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
