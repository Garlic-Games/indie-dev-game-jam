extends Camera3D

@onready var player_camera: Camera3D = $"../../../PlayerCamera";

func _process(delta):
	transform = player_camera.transform;
	rotation = player_camera.rotation;
