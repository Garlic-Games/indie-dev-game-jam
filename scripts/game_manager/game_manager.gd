extends Node

@export var hud : Control = null;
@export var camera : Camera3D = null;
@export var core : Core = null;
@export var weapon : MagnetWrench = null;
@export var game_over_screen : CanvasLayer = null;
@export var fade_manager : FadeManager = null;

var is_game_over : bool = false;
var game_time : float = 0.0;


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	fade_manager.connect("on_fade_out_ended", show_game_over_screen);
	core.connect("on_core_destroy_started", game_over);
	core.connect("on_core_destroyed", fade_out);

	game_over_screen.hide();
	
	fade_manager.fade_in(2.0);


func _process(delta):	
	if not is_game_over:
		game_time += delta;


func game_over():
	is_game_over = true;
	weapon.hide();
	hud.hide();
	core.start_core_destroy_animation(camera);


func fade_out():
	fade_manager.fade_out(2.0);


func show_game_over_screen():
	if is_game_over:
		await get_tree().create_timer(1.5).timeout;
		game_over_screen.show();
		game_over_screen.set_time_score(game_time);
