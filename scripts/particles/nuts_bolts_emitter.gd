class_name NutsBoltsEmitter
extends Node3D

@onready var tornillos: GPUParticles3D = $Tornilloszzz;
@onready var tuercas: GPUParticles3D = $Tuercaszzz;


func play():
	tornillos.emitting = true;
	tuercas.emitting = true;

func stop():
	tornillos.emitting = false;
	tuercas.emitting = false;
