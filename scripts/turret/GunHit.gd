extends GPUParticles3D

func _on_rotator_bullet_hit(position):
	global_position = position;
	emitting = true;
