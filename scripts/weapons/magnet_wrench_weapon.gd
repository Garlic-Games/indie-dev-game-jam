class_name MagnetWrench;

extends Node3D


@export var melee_swing: float = 1.5;
@export var range_swing: float = 1;

@export var player: Player;


@onready var magnet: MeshInstance3D = $Magnet;
@onready var shaft: MeshInstance3D = $Shaft;
@onready var spring: MeshInstance3D = $Spring;
@onready var beamSfx: AudioStreamPlayer3D = $BeamSFX;
@onready var nutsNBolts: NutsBoltsEmitter = $NutsBoltsEmitter;
@onready var beamArea: Area3D = $BeamArea;
@onready var verticalMeleeArea: Area3D = $MeleeAreaVertical;
@onready var horizontalMeleeArea: Area3D = $MeleeAreaHorizontal;

var _animationDuration: float = 0.4;
var _shootAnimation: Tween = null;

var _initialMagnetPosition = Vector3.ZERO;


enum Mode {HORIZONTAL = 270, VERTICAL = 0}

var _mode: Mode = Mode.VERTICAL;
var _weaponReady = true;
var _oldLookAtPosition = Vector3.ZERO;
var _originalLookAtPosition: Transform3D;

signal push_pull_force_applied(forward: bool)
signal mode_changed(oldPosition: Mode, newPosition: Mode)

func _ready():
	_originalLookAtPosition = transform;
	_initialMagnetPosition = magnet.get_position();

func ToogleMode():
	if !_weaponReady:
		return;
	_weaponReady = false;
	var oldMode = _mode;
	if(_mode == Mode.VERTICAL):
		_changeMode(Mode.HORIZONTAL);
	else:
		_changeMode(Mode.VERTICAL);
	mode_changed.emit(oldMode, _mode);


func Shoot(damage: float) -> bool:
	if !_weaponReady:
		return false;
	_weaponReady = false;
	if(_mode == Mode.VERTICAL):
		_AttackRangedVertical(damage);
	else:
		_AttackRangedHorizontal();
	return true;


func Melee(damage: float) -> bool:
	if !_weaponReady:
		return false;
	_weaponReady = false;
	if(_mode == Mode.VERTICAL):
		_AttackMeleeVertical(damage);
	else:
		_AttackMeleeHorizontal(damage);
	return true;

func _AttackMeleeHorizontal(damage: float):
	push_pull_force_applied.emit(true);
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:x", -melee_swing, _animationDuration/4);
	tween.tween_property(magnet, "position:x", melee_swing, _animationDuration/2);
	tween.tween_property(magnet, "position:x", _initialMagnetPosition.x, _animationDuration/4);
	tween.finished.connect(_animationFinished);
	_DealMeleeDamageToEnemies(horizontalMeleeArea, damage);

func _AttackMeleeVertical(damage: float):
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:y", -melee_swing, _animationDuration/4);
	tween.tween_property(magnet, "position:y", melee_swing, _animationDuration/2);
	tween.tween_property(magnet, "position:y", _initialMagnetPosition.x, _animationDuration/4);
	tween.finished.connect(_animationFinished);
	tween.finished.connect(_verticalAttackTwinFinish);
	_DealMeleeDamageToEnemies(verticalMeleeArea, damage);


func _verticalAttackTwinFinish():
	push_pull_force_applied.emit(false);

func _AttackRangedVertical(damage: float):
	beamSfx.play();
	nutsNBolts.play();
	beamSfx.pitch_scale = 1;
	_DealDamageToEnemies(damage);
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z - range_swing, _animationDuration/5);
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z, _animationDuration);
	tween.finished.connect(_animationFinished);

func _AttackRangedHorizontal():
	beamSfx.play();
	beamSfx.pitch_scale = 1.6;
	_AttractPickups();
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z - range_swing, _animationDuration);
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z, _animationDuration/5);
	tween.finished.connect(_animationFinished);


func _changeMode(newMode: Mode):
	if newMode == _mode:
		return;
	_mode = newMode;
	_animateMagnetToPosition(newMode);
	
func _animateMagnetToPosition(newPositionDegrees):
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "rotation:z", deg_to_rad(newPositionDegrees), _animationDuration);
	tween.finished.connect(_animationFinished);
	
func _animationFinished():
	nutsNBolts.stop();
	_weaponReady = true;
	beamSfx.stop();

func LookAt(lookPosition: Vector3):
	if lookPosition == Vector3.ZERO:
		transform = _originalLookAtPosition;
		return;
	if _oldLookAtPosition != Vector3.ZERO:
		lookPosition = lerp(_oldLookAtPosition, lookPosition, 0.08);
	look_at(lookPosition);
	_oldLookAtPosition = lookPosition;

func _AttractPickups():
	var impulse = 150;
	if player:
		impulse = player.global_transform.basis.z * impulse;
	else:
		impulse = global_transform.basis.z * impulse;
	for body in beamArea.get_overlapping_bodies():
		if body is RigidBody3D:
			body.apply_central_impulse(impulse)
	
func _DealDamageToEnemies(damage: float):
	for body in beamArea.get_overlapping_bodies():
		if body is BaseEnemyRobot:
			body.damage(damage);
		if body is TurretPlacement:
			body.build();

func _DealMeleeDamageToEnemies(shape: Area3D, damage: float):
	for body in shape.get_overlapping_bodies():
		if body is BaseEnemyRobot:
			body.damage(damage);
