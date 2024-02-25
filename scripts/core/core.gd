extends Node3D

signal on_core_destroyed();
signal on_core_damaged(lives_remaining : int);

@export_group("Core settings")
@export var lives : int = 5;
@export var min_rotation_speed : float = 22.5;
@export var max_rotation_speed : float = 720.0;

@export_group("Core structure")
@export var sphere : MeshInstance3D = null;
@export var rotary_item : MeshInstance3D = null;
@export var wings : Array[MeshInstance3D] = [];

var current_lives : float;
var current_rotation_speed : float;


func _ready():
	current_lives = lives;
	current_rotation_speed = min_rotation_speed;
	print(sphere.get_surface_override_material(0).get("shader_parameter/Saturation"));


func _process(delta):
	rotary_item.rotate_y(current_rotation_speed * 2.0 * PI / 360.0 * delta);


func damage():
	current_lives -= 1;
	check_wing_integrity();
	
	if (current_lives < 0):
		destroy_core();
		emit_signal("on_core_destroyed");


func check_wing_integrity():
	current_rotation_speed = lerp(min_rotation_speed, max_rotation_speed, 1.0 - float(current_lives / lives));
	var wings_remaining = ceili(current_lives / lives * wings.size());

	while (wings.size() > wings_remaining):
		# @TODO: animar la rotura del ala?
		wings.pop_back().queue_free();


func destroy_core():
	var tween = get_tree().create_tween()
	tween.tween_property(sphere.get_surface_override_material(0), "shader_parameter/Saturation", 0.0, 3)
