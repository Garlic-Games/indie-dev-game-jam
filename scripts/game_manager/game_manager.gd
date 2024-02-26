extends Node

@export var _endGameCamera : Camera3D = null;
@export var core : Core = null;
@export var player: Player = null;
@export var game_over_screen : CanvasLayer = null;
@export var fade_manager : FadeManager = null;
@export var tutorial : Tutorial = null;

@export_group("FX")
@export var coreDamagedSound: AudioStreamPlayer = null;
@export var coreDeadSound: AudioStreamPlayer = null;
@export var gameMusic: AudioStreamPlayer = null;
@export var gameOverMusic: AudioStreamPlayer = null;
@export var winMusic: AudioStreamPlayer = null;

var is_game_over : bool = false;
var game_time : float = 0.0;


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	fade_manager.connect("on_fade_out_ended", show_game_over_screen);
	player.connect("die_event", game_over);
	core.connect("on_core_death_animation", game_over);
	core.connect("on_core_destroyed", fade_out);
	core.connect("on_core_damaged", core_damaged);
	core.connect("on_core_destroy_started", core_destroyed);

	game_over_screen.hide();
	PlayMusic();
	fade_manager.fade_in(2.0);
	tutorial.start();


func PlayMusic():
	if !is_game_over:
		gameMusic.play();
		gameMusic.finished.connect(PlayMusic);


func _process(delta):
	if not is_game_over:
		game_time += delta;


func core_damaged(a,b,c):
	coreDamagedSound.play();


func core_destroyed():
	coreDeadSound.play();


func game_over():
	is_game_over = true;
	gameMusic.stop();
	player.hideWeapon();
	player.hideHud();
	core.start_core_destroy_animation(player.camera);


func fade_out():
	gameOverMusic.play();
	fade_manager.fade_out(2.0);


func show_game_over_screen():
	if is_game_over:
		await get_tree().create_timer(1.5).timeout;
		game_over_screen.show();
		game_over_screen.set_time_score(game_time);
