extends Control

@onready var _ammoLabel: Label = $Right/BottomRight/AmmoLabel;
@onready var _staminaPB: TextureProgressBar = $Right/BottomRight/StaminaProgressBar;
@onready var _coreHealthPB: TextureProgressBar = $Left/BottomLeft/CoreHealthProgressBar;
@onready var _playerHealthPB: TextureProgressBar = $Left/BottomLeft/PlayerHealthProgressBar;
@onready var _VCrossHair: Sprite2D = $Center/Crosshair;
@onready var _HCrossHair: Sprite2D = $Center/CrosshairVertical;
@onready var _texture_rect = %TextureRect;


var _actualAmmo = 150;
var _maxAmmo = 3000;
var _staminaLevel = 100;
var _playerHealthLevel = 100;
var _coreHealthLevel = 100;

func _ready():
	_setAmmoValue();
	_staminaPB.value = _staminaLevel;
	_coreHealthPB.value = _coreHealthLevel;
	_playerHealthPB.value = _playerHealthLevel;
	pass


func _setAmmoValue():
	_ammoLabel.text = "%d/%d" % [_actualAmmo, _maxAmmo];
	
func AmmoChangedListener(oldAmmo: float, newAmmo: float):
	_actualAmmo = newAmmo;
	_setAmmoValue();
	
func StaminaChangedListener(oldStamina: float, newStamina: float):
	_staminaLevel = newStamina;
	_staminaPB.value = _staminaLevel;
	
func CoreHealthChangedListener(max: int, oldCoreHealtLevel: int, newCoreHealtLevel: int):
	_coreHealthLevel = newCoreHealtLevel;
	_coreHealthPB.max_value = max + 2; #+1 porque tiene "max" patas y el toque final
	_coreHealthPB.value = _coreHealthLevel;
	
func PlayerHealthChangedListener(oldPlayerHealthLevel: float, newPlayerHealthLevel: float):
	_playerHealthLevel = newPlayerHealthLevel;
	_playerHealthPB.value = _playerHealthLevel;
	
	_texture_rect.material.set_shader_parameter("doeet", true);
	await get_tree().create_timer(0.5).timeout;
	_texture_rect.material.set_shader_parameter("doeet", false);
	
func WeaponPositionChanged(oldPosition: MagnetWrench.Mode, newPosition: MagnetWrench.Mode):
	if newPosition == MagnetWrench.Mode.HORIZONTAL:
		_HCrossHair.visible = false;
		_VCrossHair.visible = true;
	else:
		_HCrossHair.visible = true;
		_VCrossHair.visible = false;
		
