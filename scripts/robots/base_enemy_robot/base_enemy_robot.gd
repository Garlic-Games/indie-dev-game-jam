class_name BaseEnemyRobot;
extends CharacterBody3D

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

@onready var agent: NavigationAgent3D = %Agent;
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
	apply_gravity(gravity);
	if !movement_target_position:
		return;
	if loaded:
		set_movement_target(movement_target_position.global_position);
	
	if agent.is_navigation_finished():
		return;
	agent.velocity = global_position.direction_to(agent.get_next_path_position()) * movement_speed;	
	
func damage(ammount: float):
	current_hp -= ammount;
	damaged.emit(ammount);

func die():
	dead.emit();
	queue_free();	

func apply_gravity(gravity_value: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity_value;


func _on_agent_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity;
	move_and_slide();
