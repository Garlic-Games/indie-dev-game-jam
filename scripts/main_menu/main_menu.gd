extends CanvasLayer;

@onready var main_menu: PanelContainer = %MainContainer;
@onready var settings_menu: SettingsContainer = %SettingsMenu;
@onready var credits: Credits = %Credits;
@onready var loading_panel: LoadingPanel = %LoadingPanel;
@export_file("*.tscn") var gameplay_scene: String;


func _ready():
	assert(gameplay_scene != "", "A gameplay scene resource must be provided to main menu");
	
	settings_menu.connect("closed", open);
	credits.connect("closed", open);


func open():
	main_menu.show();
	
	
func close():
	main_menu.hide();


func start_game() -> void:
	SceneLoader.load_scene(gameplay_scene);


func open_settings() -> void:
	close();
	settings_menu.open();


func open_credits() -> void:
	self.close();
	credits.open();


func close_game() -> void:
	get_tree().quit();
