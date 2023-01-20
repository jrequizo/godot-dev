using Godot;
using System.Collections.Generic;

abstract public class State : Node {
    public StateMachine stateMachine;

    abstract public void Update(float delta);

    abstract public void PhysicsUpdate(float delta);

    abstract public void HandleInput(InputEvent input);

    abstract public void Enter(Dictionary<string, string> msg = null);

    abstract public void Exit();

}