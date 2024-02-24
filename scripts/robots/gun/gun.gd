extends Node3D

@export var rotation_speed: float = 2;
@export var shoot_cooldown: float = 2;

@export var target: Node3D;
@export var enemy: BaseEnemyRobot;
@onready var head_mesh: Node3D = %HeadMesh;

var fire: bool = false;
var cooldown: SceneTreeTimer;

signal shoot;

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
		shoot.emit();
		print("pium");
		cooldown = get_tree().create_timer(shoot_cooldown, false);
		cooldown.timeout.connect(open_fire);
