extends Camera3D

@export var mouse_sensitivity = .2;

@onready var player = $"../..";  

func _process(delta):
	position = Vector3(player.position.x, player.position.y + 1.75, player.position.z);
	rotation = Vector3(rotation.x, player.rotation.y, player.rotation.z);

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player.rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10;
		rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90);

