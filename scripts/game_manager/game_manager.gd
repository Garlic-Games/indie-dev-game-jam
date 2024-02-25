extends Node

@export var core : Core = null;
@export var game_over_screen : CanvasLayer = null;
@export var camera : Camera3D = null;
@export var fade_manager : FadeManager = null;

var is_game_over : bool = false;

func _ready():
	fade_manager.connect("on_fade_out_ended", show_game_over_screen);
	core.connect("on_core_destroy_started", game_over);
	core.connect("on_core_destroyed", fade_out);

	game_over_screen.hide();


func game_over():
	is_game_over = true;
	core.start_core_destroy_animation(camera);


func fade_out():
	fade_manager.fade_out(2.0);


func show_game_over_screen():
	game_over_screen.show();
