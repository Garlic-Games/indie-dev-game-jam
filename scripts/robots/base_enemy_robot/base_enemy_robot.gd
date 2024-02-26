class_name BaseEnemyRobot;
extends CharacterBody3D

@export var bolts_dropped: float = 5;
@export var max_hp: float = 10;
@onready var current_hp: float = max_hp :
	get:
		return current_hp;
	set(value):
		current_hp = value;
		if current_hp <= 0:
			die();

@export var movement_speed: float = 5;
@export var movement_target_position: Node3D;

@export var body: Node3D;
@onready var agent: NavigationAgent3D = %Agent;
const NUT_BOLT_PICKUP = preload("res://prefabs/pickup/nut_bolt_pickup.tscn");

var loaded: bool = false;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
signal damaged(dmg: float);
signal dead;

func _ready():
	loaded = false;
	# Make sure to not await during _ready.
	call_deferred("actor_setup");

func actor_setup():
	if !movement_target_position:
		return;
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame;
	loaded = true;
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position.global_position);

func set_movement_target(movement_target: Vector3):
	if agent.target_position == movement_target:
		return;
	agent.set_target_position(movement_target)

func _physics_process(_delta):
	if !movement_target_position:
		return;
	if loaded:
		set_movement_target(movement_target_position.global_position);
	
	if agent.is_navigation_finished():
		return;
	var next_pos = agent.get_next_path_position();
	if body:
		var x = body.rotation.x;
		var z = body.rotation.z;
		body.look_at(next_pos);
		body.rotation.x = x;
		body.rotation.z = z;
	agent.velocity = global_position.direction_to(next_pos) * movement_speed;	
	
func damage(ammount: float):
	current_hp -= ammount;
	damaged.emit(ammount);

func die():
	dead.emit();
	_spawn_bolts();
	queue_free();	

func _on_agent_velocity_computed(safe_velocity: Vector3):
	velocity = velocity.move_toward(safe_velocity, 0.75);
	if not is_on_floor():
		velocity.y -= gravity;
	move_and_slide();

func _on_agent_target_reached():
	velocity = Vector3.ZERO;
	
func _spawn_bolts():
	for i in bolts_dropped:
		var pickup = NUT_BOLT_PICKUP.instantiate() as NutBoltPickup;
		get_parent().add_child(pickup);
		pickup.global_position = global_position;


var player: Player;
var damage_cooldown: SceneTreeTimer;
@export_category("Melee atack")
@export var melee_damage: float = 1;
@export var melee_damage_cooldown: float = 0.5;
func _on_damage_area_body_entered(body):
	player = body as Player;
	damage_player();

func damage_player():
	if (!damage_cooldown && damage_cooldown.time_left >= 0) || !player:
		return;
	player.damage(melee_damage);
	damage_cooldown = get_tree().create_timer(melee_damage_cooldown, false);	
	await damage_cooldown.timeout;
	 damage_player();
