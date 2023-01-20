using Godot;
using System;

public class Player : KinematicBody2D
{
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";
	[Export]
	public float WALK_SPEED = 100.0f;
	[Export]
	public float RUN_SPEED = 250.0f;
	[Export]
	public float SPRINT_SPEED = 250.0f;

	[Export]
	public float DRAG = 15.0f;
	[Export]
	public float MOVEMENT_THRESHOLD = 0.1f;

	[Export]
	public double BASE_HEALTH = 100;
	[Export]
	public double BASE_MANA = 100;
	[Export]
	public double BASE_STAMINA = 100;

	public double health;
	public double mana;
	public double stamina;

	public Boolean isRunning = false;

	// What direction the player's velocity is moving in
	public int directionX = 0;
	public int directionY = 0;
	public int inputX = 0;
	public int inputY = 0;

	public Vector2 velocity = Vector2.Zero;

	public Timer staminaRecoveryTimer;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		health = BASE_HEALTH;
		mana = BASE_MANA;
		stamina = BASE_STAMINA;

		staminaRecoveryTimer = (Timer)GetNode("StaminaRecoveryTimer");
	}

	//  // Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta)
	{

	}


	public void calculateMovement(float delta, double speed) {
		inputX = (Convert.ToInt32(Input.IsActionPressed("move_right")) - Convert.ToInt32(Input.IsActionPressed("move_left")));
		inputY = (Convert.ToInt32(Input.IsActionPressed("move_up")) - Convert.ToInt32(Input.IsActionPressed("move_down")));

		if (inputX != 0) {
			directionX = inputX;
		} else {
			velocity.x -= velocity.x * DRAG * delta;
			if (velocity.x * directionX < MOVEMENT_THRESHOLD) {
				velocity.x = 0;
				directionX = 0;
			}
		}

		if (inputY != 0) {
			directionY = inputY;
		} else {
			velocity.y -= velocity.y * DRAG * delta;
			if (velocity.y * -directionY < MOVEMENT_THRESHOLD) {
				velocity.y = 0;
				directionX = 0;
			}
		}

		velocity.x += Convert.ToSingle(speed) * delta * inputX * 10;
		velocity.y += Convert.ToSingle(speed) * delta * inputX * 10;

		velocity.Normalized();

		velocity = MoveAndSlide(velocity);
	}
}
