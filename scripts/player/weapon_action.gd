extends Node

@onready var player: Player = $"..";
@onready var magnetWrench: MagnetWrench = $"../CanvasLayer/SubViewportContainer/SubViewport/Camera3D/WeaponHolder/magnet_wrench";


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event.is_action_pressed("action_primary"):
		magnetWrench.StartShootAnimation();
	else:
		magnetWrench.StopShootAnimation();
		
	if event.is_action("scroll") and event.is_pressed():
		magnetWrench.ToogleMode();
