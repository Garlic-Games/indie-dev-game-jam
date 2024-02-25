extends Node

@onready var player: Player = $"..";

@export var magnet_push_force: float = 7.0;
@export var magnetWrench: MagnetWrench;

var _forceForwardDirection = Vector3(0, 0.08, 1);
var _forceBackwardDirection = Vector3(0, 0.08, -1);


func _ready():
	magnetWrench.push_pull_force_applied.connect(_weaponAppliesKnockBack);

func _process(delta):
	if Input.is_action_pressed("action_primary"):
		magnetWrench.Shoot();
		
	if Input.is_action_pressed("action_secondary"):
		magnetWrench.Melee();


func _input(event: InputEvent):
	if event.is_action_pressed("scroll"):
		magnetWrench.ToogleMode();


func _weaponAppliesKnockBack(forward: bool):
	var direction = _forceBackwardDirection;
	if forward:
		direction = _forceForwardDirection;
	player._knockBack = direction * magnet_push_force;
