class_name Core
extends Node3D

signal on_core_damaged(lives_remaining : int);
signal on_core_destroy_started();
signal on_core_destroyed();

@export_group("Core settings")
@export var lives : int = 5;
@export var min_rotation_speed : float = 22.5;
@export var max_rotation_speed : float = 720.0;

@export_group("Core structure")
@export var collider : Area3D = null;
@export var sphere : MeshInstance3D = null;
@export var rotary_item : MeshInstance3D = null;
@export var wings : Array[MeshInstance3D] = [];

@export_group("Core settings")
@export var endgame_camera_transform : Node3D = null;

@export_group("Debug")
@export var debug_mode : bool = false;

var current_lives : float;
var current_rotation_speed : float;


func _input(event):
	if not debug_mode:
		return;

	if event.is_action_pressed("jump"):
		damage();


func _ready():
	current_lives = lives;
	current_rotation_speed = min_rotation_speed;
	sphere.get_surface_override_material(0).set("shader_parameter/Saturation", 1.0);


func _process(delta):
	rotary_item.rotate_y(current_rotation_speed * 2.0 * PI / 360.0 * delta);


func damage():
	current_lives -= 1;
	check_wing_integrity();

	if (current_lives < 0):
		emit_signal("on_core_destroy_started");


func check_wing_integrity():
	current_rotation_speed = lerp(min_rotation_speed, max_rotation_speed, 1.0 - float(current_lives / lives));
	var wings_remaining = ceili(current_lives / lives * wings.size());

	while (wings.size() > wings_remaining):
		# @TODO: animar la rotura del ala?
		var wing_rnd_index = randi_range(0, wings.size() - 1); 
		wings.pop_at(wing_rnd_index).queue_free();


func start_core_destroy_animation(camera : Camera3D):
	var tween_camera = get_tree().create_tween();
	tween_camera.tween_property(camera, "global_transform", endgame_camera_transform.global_transform, 3.0);
	tween_camera.tween_callback(destroy_core);


func destroy_core():
	var tween_core_sphere = get_tree().create_tween();
	tween_core_sphere.tween_property(sphere.get_surface_override_material(0), "shader_parameter/Saturation", 0.0, 8.0);

	var tween_core_base = get_tree().create_tween();
	tween_core_base.tween_property(self, "current_rotation_speed", 0.0, 4.0);
	tween_core_base.tween_callback(func(): emit_signal("on_core_destroyed"));


func on_body_entered(body):
	var enemy = body as BaseEnemyRobot;
	enemy.die();
	damage();
