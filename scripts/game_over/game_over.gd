extends Node

@export var time_label : Label = null;
@export var duration : float = 4.0;
@export_file("*.tscn") var main_menu_scene: String;


func set_time_score(time : float):
	time_label.text = str("Your infrastructure lasted ", snapped(time, 0.01) , " seconds");
	await get_tree().create_timer(duration).timeout;
	SceneLoader.load_scene(main_menu_scene);
	
