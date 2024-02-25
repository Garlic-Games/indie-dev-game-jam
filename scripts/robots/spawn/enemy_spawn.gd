extends Node3D

@onready var resource_preloader: ResourcePreloader = %ResourcePreloader
@export var enemy_asset: String;
@export var target: Node3D;
signal spawned;
	
func _ready():
	assert(enemy_asset, name.get_basename());
	assert(target, name.get_basename());
	assert(resource_preloader.has_resource(enemy_asset), name.get_basename());

func spawn() -> void:
	var scene = resource_preloader.get_resource(enemy_asset) as PackedScene;
	var enemy = scene.instantiate() as BaseEnemyRobot;
	get_parent().add_child(enemy);
	enemy.movement_target_position = target;
	enemy.global_position = global_position;
