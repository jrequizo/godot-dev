using Godot;
using System.Collections.Generic;

public class Running : PlayerState {
    
    public override void Enter(Dictionary<string, string> msg)
    {
        if (player.staminaRecoveryTimer.IsStopped()) {
            player.staminaRecoveryTimer.Start(1);
        }
    }

    public override void PhysicsUpdate(float delta)
    {
        if (Input.IsActionPressed("toggle_run")) {
            player.isRunning = false;
            stateMachine.TransitionTo("Walking");
        }

        if (Input.IsActionPressed("sprint")) {
            stateMachine.TransitionTo("Sprinting");
        }

        player.calculateMovement(delta, player.WALK_SPEED);

        if (Mathf.IsEqualApprox(player.inputX, 0.0f) && Mathf.IsEqualApprox(player.inputY, 0.0f)) {
            stateMachine.TransitionTo("Idle");
        }
    }
}