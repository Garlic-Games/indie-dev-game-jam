extends Node

@export_group("Weapon damage")
@export var range_damage: float = 2.7;
@export var melee_damage: float = 5;
@export var ammo_wasted_per_shoot: float = 5;
@export var magnet_push_force: float = 7.0;

@export_group("Dependencies")
@export var magnetWrench: MagnetWrench;

@onready var player: Player = $"..";

var _forceForwardDirection = Vector3(0, 0.08, 1);
var _forceBackwardDirection = Vector3(0, 0.08, -1);


func _ready():
	magnetWrench.push_pull_force_applied.connect(_weaponAppliesKnockBack);

func _process(delta):
	if Input.is_action_pressed("action_primary"):
		if player.HasEnoughAmmo(ammo_wasted_per_shoot):
			if magnetWrench.Shoot(range_damage):
				player.LooseAmmo(ammo_wasted_per_shoot);
		
	if Input.is_action_pressed("action_secondary"):
		magnetWrench.Melee(melee_damage);


func _input(event: InputEvent):
	if event.is_action_pressed("scroll"):
		magnetWrench.ToogleMode();


func _weaponAppliesKnockBack(forward: bool):
	var direction = _forceBackwardDirection;
	if forward:
		direction = _forceForwardDirection;
	player._knockBack = direction * magnet_push_force;
