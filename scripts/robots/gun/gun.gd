extends Node3D

@export var rotation_speed: float = 2;
@export var shoot_cooldown: float = 2;
@export var damage: float = 5;

@export var target: Node3D;

var cooldown: SceneTreeTimer;
const FLOOR_MASK = 1;  

signal shoot();
signal bullet_hit(position: Vector3);
	
func _process(delta: float):
	if !target:
		rotation = lerp(rotation, Vector3.ZERO, delta * rotation_speed);
		return;

	var ray = PhysicsRayQueryParameters3D.create(global_position, target.global_position, FLOOR_MASK);
	var collision = get_world_3d().direct_space_state.intersect_ray(ray);
	if !collision.is_empty():
			return;
	look_at(target.global_position, Vector3.UP);
	open_fire();
	
func _on_detection_sensor_body_entered(body: Node3D) -> void:
	target = body;

func _on_detection_sensor_body_exited(body: Node3D):
	if !target:
		return;
	if target.get_instance_id() == body.get_instance_id():
		target = null;

func open_fire():
	if cooldown && cooldown.time_left > 0:
		return; 
		
	if target:
		shoot.emit();
		if target.has_method("damage"):
			target.call("damage", damage);
		bullet_hit.emit(target.global_position);
		cooldown = get_tree().create_timer(shoot_cooldown, false);

