class_name LivingBeing
extends CharacterBody2D

@export var max_haha_points: int
var current_haha_points: int
@export var i_frames: float
var i_timer: float


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(i_timer > 0):
		i_timer -= delta;

func _take_damage(damage: int):
	if(i_timer > 0):
		return;
	current_haha_points -= damage;
	i_timer = i_frames
	if(current_haha_points < 0):
		_no_more_laughing();

func _no_more_laughing():
	pass
