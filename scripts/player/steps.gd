class_name Steps;
extends Node3D

@export var audioSources: Array[AudioStreamPlayer3D] = [];
@export var uniquePlay: bool = true;

func reproduce() -> void:
	if uniquePlay && _isAnyPlaying():
		return;
		
	audioSources.pick_random().play();
		
func stop() -> void:
	for audioSource in audioSources:
		if audioSource.playing:
			audioSource.stop();
		

func _isAnyPlaying() -> bool:
	for audioSource in audioSources:
		if audioSource.playing:
			return true;
	return false;
