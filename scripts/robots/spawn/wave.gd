extends Node

@export var wave_seconds: float = 120;
signal wave_start;
signal wave_end;

func start_wave():
	for timer in get_children():
		if timer is Timer:
			timer.start();
	wave_start.emit();
	if wave_seconds > 0:
		var timer = get_tree().create_timer(wave_seconds, false);
		timer.timeout.connect(stop_wave);
	
func stop_wave():
	for timer in get_children():
		if timer is Timer:
			timer.stop();
	wave_end.emit();
