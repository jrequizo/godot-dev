using Godot;
using System;
using System.Collections.Generic;

public class PlayerState : State
{

    public Player player;

    public override async void _Ready()
    {
        await ToSignal(Owner, "ready");
        player = (Player)Owner;
        if (player == null) throw new NullReferenceException("Player node not found.");
    }

    public override void PhysicsUpdate(float delta)
    {
    }

    public override void Update(float delta) {
    }
    public override void Enter(Dictionary<string, string> msg)
    {
    }

    public override void Exit()
    {
    }

    public override void HandleInput(InputEvent input)
    {
        
    }
}