extends Camera3D

@export var mouse_sensitivity = .2;

@onready var player = $"..";
@onready var alternativeCamera: Camera3D = $"../CanvasLayer/SubViewportContainer/SubViewport/Camera3D";



func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player.rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10;
		#rotation_degrees.y = player.rotation_degrees.y;
		rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90);
		if(alternativeCamera):
			alternativeCamera.rotation = rotation;
			alternativeCamera.position = position;
