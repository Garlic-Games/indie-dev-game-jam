extends Node

@export_group("Weapon damage")
@export var range_damage: float = 2.7;
@export var melee_damage: float = 5;
@export var ammo_wasted_per_shoot: float = 5;
@export var magnet_push_force: float = 3.0;

@export_group("Dependencies")
@export var magnetWrench: MagnetWrench;

@onready var player: Player = $"..";



func _ready():
	magnetWrench.push_pull_force_applied.connect(_weaponAppliesKnockBack);

func _process(delta):
	if Input.is_action_pressed("action_primary"):
		if player.HasEnoughAmmo(ammo_wasted_per_shoot):
			if magnetWrench.Shoot(range_damage):
				if magnetWrench._mode == MagnetWrench.Mode.VERTICAL:
					#I don't like this condition but I won't refactor it
					player.LooseAmmo(ammo_wasted_per_shoot);
		
	if Input.is_action_pressed("action_secondary"):
		magnetWrench.Melee(melee_damage);


func _input(event: InputEvent):
	if event.is_action_pressed("scroll"):
		magnetWrench.ToogleMode();


func _weaponAppliesKnockBack(forward: bool):
	var playerRotation = player.global_rotation.y;
	if forward:
		playerRotation += deg_to_rad(180);
	var direction = Vector3(sin(playerRotation), 0.6, cos(playerRotation));
	player._knockBack = direction * magnet_push_force;
