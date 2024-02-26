extends Node3D
@onready var audio_stream_player_3d = %AudioStreamPlayer3D
@onready var resource_preloader: ResourcePreloader = %ResourcePreloader
@export var enemy_asset: String;
@export var target: Node3D;
signal spawned;
	
func set_target(targ: Node3D):
	target = targ;
	
func _ready():
	assert(enemy_asset, name.get_basename());
	assert(resource_preloader.has_resource(enemy_asset), name.get_basename());
	if !is_in_group("player_chaser"):
		assert(target, name.get_basename());

func burst_spawn(ammount: int) -> void:
	for i in ammount:
		spawn();

func spawn() -> void:
	var scene = resource_preloader.get_resource(enemy_asset) as PackedScene;
	var enemy = scene.instantiate() as BaseEnemyRobot;
	get_parent().add_child(enemy);
	enemy.movement_target_position = target;
	enemy.global_position = global_position;
	enemy.dead.connect(audio_stream_player_3d.play);
