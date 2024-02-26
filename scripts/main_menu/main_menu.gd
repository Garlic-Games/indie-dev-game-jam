extends CanvasLayer;

@onready var main_menu: PanelContainer = %MainContainer;
@onready var settings_menu: SettingsContainer = %SettingsMenu;
@onready var credits: Credits = %Credits;
@onready var loading_panel: LoadingPanel = %LoadingPanel;
@onready var fade_manager: FadeManager = %FadeManager;

@export_file("*.tscn") var gameplay_scene: String;


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	assert(gameplay_scene != "", "A gameplay scene resource must be provided to main menu");
	
	settings_menu.connect("closed", open);
	credits.connect("closed", open);
	fade_manager.connect("on_fade_out_ended", load_game);
	
	fade_manager.fade_in(2);


func open():
	main_menu.show();
	
	
func close():
	main_menu.hide();


func load_game():
	SceneLoader.load_scene(gameplay_scene);


func start_game() -> void:
	fade_manager.fade_out(2);


func open_settings() -> void:
	close();
	settings_menu.open();


func open_credits() -> void:
	self.close();
	credits.open();


func close_game() -> void:
	get_tree().quit();
