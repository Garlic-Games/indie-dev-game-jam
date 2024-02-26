extends StaticBody3D

@export var max_hp: float = 10;
@onready var current_hp: float = max_hp :
	get:
		return current_hp;
	set(value):
		current_hp = value;
		if current_hp <= 0:
			die();

signal damaged(dmg: float);
signal dead;

func damage(ammount: float):
	current_hp -= ammount;
	damaged.emit(ammount);

func die():
	dead.emit();
	queue_free();	
	
