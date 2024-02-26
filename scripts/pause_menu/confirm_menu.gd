class_name ConfirmMenu;
extends Control

signal selection(choice: bool);
signal opened;
signal closed;

func _input(event: InputEvent):
	if event.is_action_pressed("pause"):
		close();

func _ready() -> void:
	hide();

func open() -> void:
	opened.emit();
	show();

func close():
	closed.emit();
	hide();

func _on_yes_pressed():
	selection.emit(true);

func _on_no_pressed():
	selection.emit(false);
