extends Node3D

@export var rotation_speed: float = 2;
@export var shoot_cooldown: float = 2;
@export var damage: float = 5;

@export var target: Node3D;

var fire: bool = false;
var cooldown: SceneTreeTimer;
const FLOOR_MASK = 1;  

signal shoot(impact: Vector3);

func _process(delta: float):
	if !target:
		return;

	var target_vector = global_position.direction_to(target.global_position)
	var target_basis = Basis.looking_at(target_vector)
	basis = basis.slerp(target_basis, 0.5)


func _on_detection_sensor_body_entered(body: Node3D) -> void:
	target = body;# Replace with function body.

func _on_detection_sensor_body_exited(body: Node3D):
	target = null;	


func _on_shoot_area_body_entered(body):
	fire = true;
	open_fire();


func _on_shoot_area_body_exited(body):
	fire = false;

func open_fire():
	if cooldown && cooldown.time_left > 0:
		return; 
	
	if fire && target:
		var ray = PhysicsRayQueryParameters3D.create(global_position, target.global_position, FLOOR_MASK);
		var collision = get_world_3d().direct_space_state.intersect_ray(ray);
		if collision.is_empty() || !collision.collider.has_method("damage"):
			return;

		collision.collider.call("damage", damage);
		shoot.emit(collision.position);
		
		cooldown = get_tree().create_timer(shoot_cooldown, false);
		cooldown.timeout.connect(open_fire);
