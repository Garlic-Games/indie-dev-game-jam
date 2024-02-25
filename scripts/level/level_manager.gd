extends Node3D

@export var level_start_timer: int = 10;
@export var player: Player;
signal level_started;
# Called when the node enters the scene tree for the first time.
func _ready():
	assert(player);
	get_tree().call_group("player_chaser", "set_target", player);
	await get_tree().create_timer(level_start_timer, false).timeout;
	level_started.emit();

