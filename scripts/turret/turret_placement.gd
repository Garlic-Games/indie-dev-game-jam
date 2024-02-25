class_name TurretPlacement;
extends Node3D

signal progress(ammount: float, max_value: float)
signal built;

@export var max_build: float = 100;
@export var build_per_tick: float = 10;

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
