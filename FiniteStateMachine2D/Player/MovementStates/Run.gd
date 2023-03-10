extends PlayerState


func physics_update(delta: float) -> void:
	# Notice how we have some code duplication between states. That's inherent to the pattern,
	# although in production, your states will tend to be more complex and duplicate code
	# much more rare.
	if not player.is_on_floor():
		state_machine.transition_to("Air")
		return

	# We move the run-specific input code to the state.
	# A good alternative would be to define a `get_input_direction()` function on the `Player.gd`
	# script to avoid duplicating these lines in every script.
	
	# Horizontal movement
	var input_direction_x: float = (
		Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left")
	)
	
	if (input_direction_x != 0):
		player.movement_direction_x = input_direction_x
		
	player.velocity.x += player.MOVEMENT_SPEED * delta * input_direction_x * 10
	player.velocity.x = clamp(player.velocity.x, -player.MOVEMENT_SPEED, player.MOVEMENT_SPEED)
	# Vertical movement
	player.velocity.y += player.GRAVITY_ACCELERATION * delta
	# Update movement.
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if Input.is_action_pressed("move_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
