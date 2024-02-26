extends Camera3D

@export var mouse_sensitivity = .2;

@onready var _lineDrawer = $"/root/DrawLine3d";
@onready var _rayCaster: RayCast3D = $RayCast3D;
@onready var player = $"..";

signal aim_point_physics_update(aim_to: Vector3);


func _physics_process(delta):
	if _rayCaster.is_colliding():
		var collidingTo = _rayCaster.get_collision_point();
		aim_point_physics_update.emit(collidingTo);
	else:
		aim_point_physics_update.emit(Vector3.ZERO);

	

func _getCameraCenter():
	return get_viewport().size / 2;

func _input(event):
	if event is InputEventMouseMotion:# and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player.rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10;
		rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90);
