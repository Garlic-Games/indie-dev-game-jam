class_name Core
extends Node3D

signal on_core_destroyed();
signal on_core_destroy_started();
signal on_core_death_animation();
signal on_core_damaged(max_lives: int, beforeLives: int, afterLives: int);

@export_group("Core settings")
@export var wing_health : int = 1;
@export var core_health : int = 2;
@export var min_rotation_speed : float = 22.5;
@export var max_rotation_speed : float = 920.0;

@export_group("Core structure")
@export var collider : Area3D = null;
@export var sphere : MeshInstance3D = null;
@export var rotary_item : MeshInstance3D = null;
@export var wings : Array[MeshInstance3D] = [];

@export_group("Core settings")
@export var endgame_camera_transform : Node3D = null;

@export_group("Debug")
@export var debug_mode : bool = false;

var _totalHealth: int;
var _currentHealth : int;
var current_rotation_speed : float;


func _input(event):
	if not debug_mode:
		return;
		
	if event.is_action_pressed("jump"):
		damage(1);
		

func _ready():
	_totalHealth = (wing_health * wings.size()) + core_health;
	_currentHealth = _totalHealth;
	current_rotation_speed = min_rotation_speed;
	sphere.get_surface_override_material(0).set("shader_parameter/Saturation", 1.0);


func _process(delta):
	rotary_item.rotate_y(current_rotation_speed * 2.0 * PI / 360.0 * delta);


func damage(amount: int):
	var newHealth = _currentHealth - amount;
	on_core_damaged.emit(_totalHealth, _currentHealth, newHealth);
	_currentHealth = newHealth;
	check_wing_integrity();
	
	if (_currentHealth <= 0):
		emit_signal("on_core_death_animation");


func check_wing_integrity():
	var wingsHealth = _currentHealth - core_health;
	var wings_remaining = ceili(wingsHealth / wing_health);

	while (wings.size() > wings_remaining && wings.size() > 0):
		# @TODO: animar la rotura del ala?
		var wing_rnd_index = randi_range(0, wings.size() - 1); 
		wings.pop_at(wing_rnd_index).queue_free();
		
	if _currentHealth <= 0:
		return;
	
	var remainingHealthPercent = 1.0 - (float(_currentHealth) / float(_totalHealth));
	current_rotation_speed = min_rotation_speed + (max_rotation_speed - min_rotation_speed) * remainingHealthPercent;




func start_core_destroy_animation(camera : Camera3D):
	var tween_camera = get_tree().create_tween();
	tween_camera.tween_property(camera, "global_transform", endgame_camera_transform.global_transform, 3.0);
	tween_camera.tween_callback(destroy_core);


func destroy_core():
	emit_signal("on_core_destroy_started");
	var tween_core_sphere = get_tree().create_tween();
	tween_core_sphere.tween_property(sphere.get_surface_override_material(0), "shader_parameter/Saturation", 0.0, 8.0);

	var tween_core_base = get_tree().create_tween();
	tween_core_base.tween_property(self, "current_rotation_speed", 0.0, 4.0);
	tween_core_base.tween_callback(func(): emit_signal("on_core_destroyed"));


func on_body_entered(body):
	var enemy = body as BaseEnemyRobot;
	enemy.die();
	damage(1);
