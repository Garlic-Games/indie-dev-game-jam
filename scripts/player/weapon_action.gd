extends Node

@onready var player: Player = $"..";

@export var magnet_push_force: float = 10.0;
@export var magnetWrench: MagnetWrench;

var _forceForwardDirection = Vector3(0, 0.08, 1);
var _forceBackwardDirection = Vector3(0, 0.08, -1);


func _ready():
	magnetWrench.push_pull_force_applied.connect(_weaponAppliesKnockBack);


func _input(event):
	if event.is_action_pressed("action_primary"):
		magnetWrench.Melee();

	if event.is_action_pressed("action_secondary"):
		magnetWrench.Shoot();

	if event.is_action_pressed("scroll"):
		magnetWrench.ToogleMode();


func _weaponAppliesKnockBack(forward: bool):
	var direction = _forceBackwardDirection;
	if forward:
		direction = _forceForwardDirection;
	player._knockBack = direction * magnet_push_force;
