using Godot;
using System.Collections.Generic;

public class Sprinting : PlayerState {
    
    public override void Enter(Dictionary<string, string> msg)
    {
        if (player.staminaRecoveryTimer.IsStopped()) {
            player.staminaRecoveryTimer.Start(1);
        }
    }

    public override void PhysicsUpdate(float delta)
    {
        if (Input.IsActionJustReleased("sprint") || player.stamina <= 0) {
            if (player.isRunning) {
                stateMachine.TransitionTo("Running");
            } else {
                stateMachine.TransitionTo("Walking");
            }
        }
        
        EmitSignal("SetStamina", player.stamina - delta * 5);

        player.calculateMovement(delta, player.WALK_SPEED);

        if (Mathf.IsEqualApprox(player.inputX, 0.0f) && Mathf.IsEqualApprox(player.inputY, 0.0f)) {
            stateMachine.TransitionTo("Idle");
        }
    }
    
}