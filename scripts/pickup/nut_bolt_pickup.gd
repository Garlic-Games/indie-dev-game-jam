class_name NutBoltPickup;

extends RigidBody3D

@onready var _boltMesh: MeshInstance3D = $BoltMesh;
@onready var _nutMesh: MeshInstance3D = $NutMesh;

@export var _colorOverride: Array[String] = ["9e9e9e", "9e9eff", "9eff9e", "ff9e9e"];
@export var baseMaterial: StandardMaterial3D = null;

static var _rng = RandomNumberGenerator.new();
static var _rng2 = RandomNumberGenerator.new();

func _ready():
	var bolt: bool = _rng.randi_range(0,1) > 0;
	var color: int = _rng2.randi_range(0,_colorOverride.size()-1);
	var materialCopy = baseMaterial.duplicate()
	materialCopy.albedo_color = _colorOverride[color];
	if bolt:
		_nutMesh.visible = false;
		_boltMesh.set_surface_override_material(0, materialCopy);
	else:
		_nutMesh.set_surface_override_material(0, materialCopy);
		_boltMesh.visible = false;
	



func _on_area_3d_body_entered(body):
	if body as Player:
		body.AddAmmo();
		get_parent().remove_child(self);
		queue_free();

