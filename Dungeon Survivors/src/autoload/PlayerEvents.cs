using Godot;

public class PlayerEvents : Node
{
    [Signal]
    delegate void SetStamina(float stamina);
}
