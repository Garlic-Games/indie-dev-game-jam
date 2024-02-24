class_name Player;
extends CharacterBody3D

@export_group("Player playersettings")
@export var walk_speed: float = 7.0;
@export var run_speed: float = 12.0;
@export var jump_speed: float = 5.0;
@export var sensitivity: float = 2.0;
@export_group("Stamina settings")
@export var stamina_increase_ratio: float = 15.0;
@export var stamina_decrease_ratio: float = 30.0;

@export_group("Dependencies")
@export var model: MaleBody = null;
@export var steps: Steps = null;

signal stamina_changed(before: float, after: float);
signal health_changed(before: float, after: float);
signal ammo_changed(before: float, after: float);
signal core_health_changed(before: float, after: float);

var _currentStamina: float = 100;
var _currentHealth: float = 100;
var _currentAmmo: float = 250;
var _knockBack: Vector3 = Vector3.ZERO;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

func _ready():
	stamina_changed.emit(0, _currentStamina);
	health_changed.emit(0, _currentHealth);
	ammo_changed.emit(0, _currentAmmo);
	

func _physics_process(delta):
	# Add the gravity.
	apply_gravity(gravity * delta);
	var mov_speed = walk_speed;
	var newStamina = _currentStamina;
	if Input.is_action_pressed("sprint"):
		newStamina -= stamina_decrease_ratio * delta;
		if(newStamina > 0):
			mov_speed = run_speed;
		if(newStamina < 0):
			newStamina = 0;
	else:
		newStamina += stamina_increase_ratio * delta;
		if newStamina > 100:
			newStamina = 100;
	if(newStamina != _currentStamina):
		stamina_changed.emit(_currentStamina, newStamina);
		_currentStamina = newStamina	
	
	if is_on_floor() && Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed;

	var direction = get_direction();
	if  direction == Vector3.ZERO:
		_stop();
	else:
		if is_on_floor():
			_walk();
		else:
			_stop();
	apply_velocity(direction, mov_speed);
	move_and_slide();
	_knockBack.x = lerp(_knockBack.x, 0.0, 0.2);
	_knockBack.y = lerp(_knockBack.y, 0.0, 0.5);
	_knockBack.z = lerp(_knockBack.z, 0.0, 0.2);


func _walk():
	if model:
		model.walk();
	if steps:
		steps.walk();


func _stop():
	if model:
		model.idle();
	if steps:
		steps.stop();


func apply_velocity(direction: Vector3, speed: float) -> void:
	if direction:
		velocity.x = direction.x * speed;
		velocity.z = direction.z * speed;
	else:
		velocity.x = move_toward(velocity.x, 0, speed);
		velocity.z = move_toward(velocity.z, 0, speed);
	velocity = velocity + _knockBack;


func get_direction() -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * sensitivity;
	return direction;


func apply_gravity(gravity_value: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity_value;

func damage(amount: float):
	pass;

func CoreHealthChangedListener(oldValue: float, newValue: float):
	core_health_changed.emit(oldValue, newValue);
