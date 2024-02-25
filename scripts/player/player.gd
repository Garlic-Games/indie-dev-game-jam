class_name Player;
extends CharacterBody3D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity");

@export_group("Player playersettings")
@export var walk_speed: float = 5.0;
@export var run_speed: float = 7.0;
@export var jump_speed: float = gravity/2;
@export var sensitivity: float = 2.0;
@export_group("Stamina settings")
@export var stamina_increase_ratio: float = 15.0;
@export var stamina_decrease_ratio: float = 30.0;

@export_group("Dependencies")
@export var model: MaleBody = null;
@export var stepsSfx: SFXRandomPlayer = null;
@export var pickupSfx: SFXRandomPlayer = null;

signal die_event();
signal stamina_changed(before: float, after: float);
signal health_changed(before: float, after: float);
signal ammo_changed(before: float, after: float);
signal core_health_changed(before: float, after: float);

var _currentStamina: float = 100;
var _currentHealth: float = 100;
var _currentAmmo: float = 250;
var _knockBack: Vector3 = Vector3.ZERO;
var _wasOnFloor: bool = true;

func _ready():
	stamina_changed.emit(0, _currentStamina);
	health_changed.emit(0, _currentHealth);
	ammo_changed.emit(0, _currentAmmo);
	

func _physics_process(delta):
	var isNowOnFlor: bool = is_on_floor();
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
	
	if isNowOnFlor && Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed;

	var direction = get_direction();
	if direction == Vector3.ZERO:
		_stop();
	else:
		if isNowOnFlor:
			_walk();
		else:
			_stop();
	apply_velocity(direction, mov_speed);
	if _knockBack != Vector3.ZERO:
		velocity += _knockBack;
		_knockBack = Vector3.ZERO;
	move_and_slide();
	if isNowOnFlor && !_wasOnFloor:
		_land();
	_wasOnFloor = isNowOnFlor;


func _walk():
	if model:
		model.walk();
	if stepsSfx:
		stepsSfx.reproduce();


func _stop():
	if model:
		model.idle();
	#if stepsSfx:
		#stepsSfx.stop();

func _land():
	if model:
		model.land();
	if stepsSfx:
		stepsSfx.reproduceAll(0.04);

func apply_velocity(direction: Vector3, speed: float) -> void:
	if !is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, 0.01);
		velocity.z = lerp(velocity.z, 0.0, 0.01);
	else:
		if direction:
			velocity.x = direction.x * speed;
			velocity.z = direction.z * speed;
		else:
			velocity.x = move_toward(velocity.x, 0, speed);
			velocity.z = move_toward(velocity.z, 0, speed);


func get_direction() -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() * sensitivity;
	return direction;


func apply_gravity(gravity_value: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity_value;

func damage(amount: float):
	var newHealth = _currentHealth - amount;
	if(newHealth < 0):
		die_event.emit(); #DEP
		return;
	health_changed.emit(_currentHealth, newHealth);
	_currentHealth = newHealth;

func LooseAmmo(amount: float):
	var newAmmo = _currentAmmo - amount;
	ammo_changed.emit(_currentAmmo, newAmmo);
	_currentAmmo = newAmmo;
	

func AddAmmo(amount: float):
	var newAmmo = _currentAmmo + amount;
	ammo_changed.emit(_currentAmmo, newAmmo);
	_currentAmmo = newAmmo;
	pickupSfx.reproduce();

func CoreHealthChangedListener(oldValue: float, newValue: float):
	core_health_changed.emit(oldValue, newValue);
	

func HasEnoughAmmo(amount: float) -> bool:
	return _currentAmmo > amount;
