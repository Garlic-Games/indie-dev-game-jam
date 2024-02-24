class_name MagnetWrench;

extends Node3D

@export var melee_swing: float = 1.5;
@export var range_swing: float = 1;


@onready var magnet: MeshInstance3D = $Magnet;
@onready var shaft: MeshInstance3D = $Shaft;
@onready var spring: MeshInstance3D = $Spring;

var _animationDuration: float = 0.4;
var _shootAnimation: Tween = null;

var _initialMagnetPosition = Vector3.ZERO;


enum Mode {HORIZONTAL = 270, VERTICAL = 0}

var _mode: Mode = Mode.VERTICAL;
var _weaponReady = true;

signal push_pull_force_applied(forward: bool)

func _ready():
	_initialMagnetPosition = magnet.get_position();

func ToogleMode():
	if !_weaponReady:
		return;
	_weaponReady = false;
	if(_mode == Mode.VERTICAL):
		_changeMode(Mode.HORIZONTAL);
	else:
		_changeMode(Mode.VERTICAL);


func Shoot():
	if !_weaponReady:
		return;
	_weaponReady = false;
	if(_mode == Mode.VERTICAL):
		_AttackRangedVertical();
	else:
		_AttackRangedHorizontal();
	pass;


func Melee():
	if !_weaponReady:
		return;
	_weaponReady = false;
	if(_mode == Mode.VERTICAL):
		_AttackMeleeVertical();
	else:
		_AttackMeleeHorizontal();
	pass;

func _AttackMeleeHorizontal():
	push_pull_force_applied.emit(true);
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:x", -melee_swing, _animationDuration/4);
	tween.tween_property(magnet, "position:x", melee_swing, _animationDuration/2);
	tween.tween_property(magnet, "position:x", _initialMagnetPosition.x, _animationDuration/4);
	tween.finished.connect(_animationFinished);

func _AttackMeleeVertical():
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:y", -melee_swing, _animationDuration/4);
	tween.tween_property(magnet, "position:y", melee_swing, _animationDuration/2);
	tween.tween_property(magnet, "position:y", _initialMagnetPosition.x, _animationDuration/4);
	tween.finished.connect(_animationFinished);
	tween.finished.connect(_verticalAttackTwinFinish);

func _verticalAttackTwinFinish():
	push_pull_force_applied.emit(false);

func _AttackRangedVertical():
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z - range_swing, _animationDuration/5);
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z, _animationDuration);
	tween.finished.connect(_animationFinished);

func _AttackRangedHorizontal():
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z - range_swing, _animationDuration);
	tween.tween_property(magnet, "position:z", _initialMagnetPosition.z, _animationDuration/5);
	tween.finished.connect(_animationFinished);

func _startShootAnimation():
	if _shootAnimation == null || _shootAnimation.finished:
		var tween = get_tree().create_tween().set_parallel(true);
		tween.tween_property(magnet, "position:z", -1.8, _animationDuration);
		tween.tween_property(magnet, "rotation:z", deg_to_rad(360), _animationDuration);
		var chainBack = tween.chain();
		chainBack.tween_property(magnet, "position:z", _initialMagnetPosition.z, _animationDuration);
		chainBack.tween_property(magnet, "rotation:z", 0, _animationDuration);
		chainBack.set_loops(-1)
		_shootAnimation = chainBack;

func _stopShootAnimation():
	if _shootAnimation != null:
		_shootAnimation.set_loops(1);
		

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
	_weaponReady = true;
