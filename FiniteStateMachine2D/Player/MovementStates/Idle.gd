extends PlayerState


# Upon entering the state, we set the Player noed's velocity to zero.
func enter(_msg := {}) -> void:
	pass
	

func update(delta: float) -> void:
	# If you have platforms that break when standing on them, you need that check for
	# the character to fall.
	if not owner.is_on_floor():
		state_machine.transition_to("Air")
		return
		
	player.velocity.x -= player.velocity.x * player.DRAG * delta
	if player.velocity.x * player.movement_direction_x < player.MOVEMENT_THRESHOLD:
		player.velocity.x = 0
		player.movement_direction_x = 0
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("move_up"):
		# As we'll only have one air state for both jump and fall, we use the `msg` dictionary
		# to tell the next state that we want to jump.
		state_machine.transition_to("Air", {do_jump = true})
	elif Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		state_machine.transition_to("Run")
