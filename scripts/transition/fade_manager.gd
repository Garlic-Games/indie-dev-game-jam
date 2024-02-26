class_name FadeManager
extends CanvasLayer

signal on_fade_in_ended();
signal on_fade_out_ended();

@onready var fade_background : ColorRect = %FadeBackground;


func fade_in(time : float):
	var tween_fade_in = get_tree().create_tween();
	tween_fade_in.tween_property(fade_background, "color:a", 0.0, time);
	tween_fade_in.tween_callback(func(): emit_signal("on_fade_in_ended"));
	
	
func fade_out(time : float):
	var tween_fade_out = get_tree().create_tween();
	tween_fade_out.tween_property(fade_background, "color:a", 1.0, time);
	tween_fade_out.tween_callback(func(): emit_signal("on_fade_out_ended"));
