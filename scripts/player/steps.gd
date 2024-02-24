class_name SFXRandomPlayer;
extends Node3D

@export var audioSources: Array[AudioStreamPlayer3D] = [];
@export var uniquePlay: bool = true;

var random: RandomNumberGenerator = RandomNumberGenerator.new();

func reproduce() -> void:
	if uniquePlay && _isAnyPlaying():
		return;
		
	if random.randf() > 0.5:
		step1.play(0);
	else:
		step2.play(0);
		
func stop() -> void:
	step1.stop();
	step2.stop();
		

func _isAnyPlaying() -> bool:
	for audioSource in audioSources:
		if audioSource.playing:
			return true;
	return false;
