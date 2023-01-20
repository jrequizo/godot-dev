using Godot;
using System.Collections.Generic;

public class StateMachine : Node {
    [Signal]
    delegate void transitioned(string stateName);
    
    [Export(PropertyHint.File, "*.cs")]
    public NodePath initialState;

    public State state;

    public override async void _Ready()
    {
        base._Ready();
        state = (State)GetNode(initialState);

        await ToSignal(Owner, "ready");

        foreach (State child in GetChildren()) {
            child.stateMachine = this;
        }

        state.Enter();
    }

    public void TransitionTo(string targetStateName, Dictionary<string, string> msg = null) {
        if (!HasNode(targetStateName)) {
            return;
        }

        state.Exit();
        state = (State)GetNode(targetStateName);
        state.Enter(msg);
        EmitSignal("transitioned", state.Name);
    }
}