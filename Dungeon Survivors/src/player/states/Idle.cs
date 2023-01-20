using Godot;
using System.Collections.Generic;

public class Idle : PlayerState {

    public override void Enter(Dictionary<string, string> msg)
    {
        if (player.staminaRecoveryTimer.IsStopped()) {
            player.staminaRecoveryTimer.Start(1);
        }
    }

    public override void Update(float delta)
    {
        player.calculateMovement(delta, 0);

        if (Input.IsActionJustPressed("toggle_run")) {
            player.isRunning = !player.isRunning;
        }

        if (Input.IsActionPressed("move_left") || Input.IsActionPressed("move_left") || Input.IsActionPressed("move_left") || Input.IsActionPressed("move_left")) {
            if (player.isRunning) {
                stateMachine.TransitionTo("Running");
            } else {
                stateMachine.TransitionTo("Walking");
            }
        }
    }
}