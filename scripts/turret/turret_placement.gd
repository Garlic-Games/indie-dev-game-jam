class_name TurretPlacement;
extends Node3D

signal progress(ammount: float, max_value: float)
signal built;

@export var max_build: float = 100;
@export var build_per_tick: float = 10;

@export_category("Debug")
@export var debug: bool = false;
static var turret_prefab = preload("res://prefabs/turrets/NormalTurret/normal_turret.tscn");

var current_build: float = 0:
	get:
		return current_build;
	set(value):
		current_build = value;
		if current_build >= max_build:
			build_finished();

func build() -> float:
	current_build += build_per_tick;
	progress.emit(current_build, max_build);
	return current_build;

func build_finished():
	built.emit();
	var turret = turret_prefab.instantiate();
	get_parent().add_child(turret);
	turret.global_position = global_position;
	queue_free();

func _input(event: InputEvent):
	if !debug || !event.is_action_pressed("jump"):
		return;
	build();
