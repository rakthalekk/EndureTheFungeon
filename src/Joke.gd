class_name Joke
extends Node

@export var is_automatic: bool
@export var is_charging: bool
@export var charge_delay: float
var charge_timer: float
@export var fire_delay: float
var delay_timer: float
@export var max_uses: int
var current_uses: int
var firing: bool
var can_fire: bool
var current_heading = Vector2.ZERO
var fire_pos = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	current_uses = max_uses
	delay_timer = fire_delay
	charge_timer = charge_delay
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_charging && can_fire && firing):
		charge_timer -= delta
		if(charge_timer < 0 && is_automatic):
			_tell_joke()
	if(is_automatic && !can_fire):
		delay_timer -= delay_timer
		if(delay_timer < 0):
			delay_timer = fire_delay;
			can_fire = true
	if(is_automatic && firing && can_fire):
		_tell_joke()
	pass
	
func _set_heading(heading: Vector2, position: Vector2):
	current_heading = heading;
	
func _tell_joke():
	if(!can_fire):
		return;
	#spawn bullet and set direction
	if(!is_automatic):
		can_fire = false
	if(is_charging):
		charge_timer = charge_delay
	pass
	
func _start_telling_joke():
	if(firing || !can_fire || current_uses <= 0):
		return;
	firing = true;
	if(is_automatic || is_charging):
		return;
	_tell_joke()
	pass
	
func _stop_telling_joke():
	if(is_charging && !is_automatic):
		if(charge_timer < 0):
			_tell_joke()
		else:
			charge_timer = charge_delay
	
	if(!is_automatic):
		can_fire = true;
	firing = false;
	pass
