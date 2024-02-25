class_name BaseEnemyRobot;
extends CharacterBody3D

@export var focus_player: bool = false;
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
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var agent: NavigationAgent3D = %Agent;
var loaded: bool = false;

signal damaged(dmg: float);
signal dead;

func _ready():
	loaded = false;
	agent.avoidance_enabled = true;
	agent.path_desired_distance = 0.5
	agent.target_desired_distance = 0.5

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
	agent.set_target_position(movement_target)

func _physics_process(_delta):
	if !movement_target_position:
		return;
	if loaded:
		set_movement_target(movement_target_position.global_position);
	
	if agent.is_navigation_finished():
		return;
	velocity = global_position.direction_to(agent.get_next_path_position()) * movement_speed;	
	
	move_and_slide()
	
func damage(ammount: float):
	current_hp -= ammount;
	damaged.emit(ammount);

func die():
	dead.emit();
	queue_free();	

