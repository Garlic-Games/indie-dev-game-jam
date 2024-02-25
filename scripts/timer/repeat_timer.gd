extends Timer;

@export var times_to_repeat: int = -1;
var remaining_repeats: int;

signal last_timeout;

# Called when the node enters the scene tree for the first time.
func _ready():
	if one_shot || times_to_repeat <= 0:
		return;
	remaining_repeats = times_to_repeat;
	timeout.connect(_reduce_repeats);

func _reduce_repeats():
	remaining_repeats -= 1;
	if remaining_repeats <= 0:
		timeout.disconnect(_reduce_repeats);
		last_timeout.emit();
		stop();
