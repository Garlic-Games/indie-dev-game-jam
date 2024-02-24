class_name MagnetWrench;

extends Node3D


@onready var magnet = $Magnet;
@onready var shaft = $Shaft;
@onready var spring = $Spring;

var _animationDuration: float = 0.4;
var _shootAnimation: Tween = null;


enum Mode {HORIZONTAL = 0, VERTICAL = 270}

var _mode: Mode = Mode.VERTICAL;
var _weaponReady = true;

func _ready():
	pass;

func StartShootAnimation():
	if _shootAnimation == null || _shootAnimation.finished:
		var tween = get_tree().create_tween().set_parallel(true);
		tween.tween_property(magnet, "position:z", -1.8, _animationDuration);
		tween.tween_property(magnet, "rotation:z", deg_to_rad(360), _animationDuration);
		var chainBack = tween.chain();
		chainBack.tween_property(magnet, "position:z", -1.257, _animationDuration);
		chainBack.tween_property(magnet, "rotation:z", 0, _animationDuration);
		chainBack.set_loops(-1)
		_shootAnimation = chainBack;

func StopShootAnimation():
	if _shootAnimation != null:
		_shootAnimation.set_loops(1);
		
func ToogleMode():
	if(_mode == Mode.VERTICAL):
		_changeMode(Mode.HORIZONTAL);
	else:
		_changeMode(Mode.VERTICAL);

func _changeMode(newMode: Mode):
	if newMode == _mode || !_weaponReady:
		return;
	_mode = newMode;
	_animateMagnetToPosition(newMode);
	
func _animateMagnetToPosition(newPositionDegrees):
	_weaponReady = false;
	var tween = get_tree().create_tween();
	tween.tween_property(magnet, "rotation:z", deg_to_rad(newPositionDegrees), _animationDuration);
	tween.finished.connect(_animationFinished);
	
func _animationFinished():
	_weaponReady = true;
