class_name Player
extends CharacterBody2D

var heading = Vector2.ZERO;
@export var max_haha_points: int
var current_haha_points: int
@export var i_frames: float
var i_timer: float

var jokes: Array[Joke]
var currentJoke: int

const SPEED = 300.0

func _ready():
	jokes.append(JokeDatabase._get_laugh());
	currentJoke = 0;

func _process(delta):
	var mousePos = get_global_mouse_position();
	heading = mousePos - global_position;
	if(i_timer > 0):
		i_timer -= delta;

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	velocity = direction * SPEED
	
	move_and_slide()
	
func _take_damage(damage: int):
	if(i_timer > 0):
		return;
	current_haha_points -= damage;
	i_timer = i_frames
	if(current_haha_points < 0):
		_no_more_laughing();
		
func _no_more_laughing():
	#call game over
	pass
