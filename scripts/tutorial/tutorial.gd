class_name Tutorial
extends Control

@export var label_subtitles : Label = null;
@export var panel : ColorRect = null;


func start():
	var tween_subtitle = get_tree().create_tween();
	tween_subtitle.tween_interval(3.0);
	tween_subtitle.tween_property(panel, "color:a", 0.0, 0.5);
	tween_subtitle.tween_interval(1.0);
	tween_subtitle.tween_property(label_subtitles, "text", "You must defend WARMED CORE at all costs. \nBut worry do not: your precious magneto-weapon will help you on achieving this task.", 6.0);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(label_subtitles, "text", "It has two modes of operation. \nChange them pressing Q.", 2.8);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(label_subtitles, "text", "One of them attracts bolts pressing MOUSE1. \nPick bolts and nuts from dead enemies.", 3.0);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(label_subtitles, "text", "The other shoots them pressing MOUSE1. \nShoot bolts to the turrets to repair them.", 3.0);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(label_subtitles, "text", "If you press MOUSE2 you can also attack your enemies to get precious bolts.", 2.6);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(label_subtitles, "text", "Repair your turrets and attack your enemies to defend WARMED CORE.", 3.0);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(label_subtitles, "text", "Press P to stop time.", 1.5);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(label_subtitles, "text", "Good luck on your mission.", 1.3);
	tween_subtitle.tween_interval(2.0);
	tween_subtitle.tween_property(label_subtitles, "text", "", 0.0);
	tween_subtitle.tween_property(panel, "color:a", 0.0, 0.5);
	tween_subtitle.is_queued_for_deletion();
