extends CharacterBody3D

@export var movement_speed: float = 5;
@export var movement_target_position: Node3D;
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var agent: NavigationAgent3D = %Agent;
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");
var loaded = false;

func _ready():
	loaded = false;
	agent.avoidance_enabled = true;
	agent.path_desired_distance = 0.5
	agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup");

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame;
	loaded = true;
	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position.global_position);

func set_movement_target(movement_target: Vector3):
	agent.set_target_position(movement_target)

func _physics_process(_delta):
	if loaded:
		set_movement_target(movement_target_position.global_position);
	
	if agent.is_navigation_finished():
		return;
	velocity = global_position.direction_to(agent.get_next_path_position()) * movement_speed;	
	
	move_and_slide()
	
