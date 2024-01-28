class_name Joke
extends Node

const BASE_PROJECTILE = preload("res://src/projectile.tscn")

@export var text_name: String
@export var description: String
@export var projectile_name: String
@export var num_bullets: int
@export var is_automatic: bool
@export var is_charging: bool
@export var charge_delay: float
var charge_timer: float
@export var fire_delay: float
var delay_timer: float
@export var infinite_ammo: bool
@export var max_uses: int
@export var spread: float
@export var use_random_spread: bool
var current_uses: int
var firing: bool
var can_fire: bool
var current_heading = Vector2.ZERO
var fire_pos = Vector2.ZERO

var owning_player: Player


# Called when the node enters the scene tree for the first time.
func _ready():
	current_uses = max_uses
	charge_timer = charge_delay
	can_fire = true
	if(num_bullets < 0):
		num_bullets = 0
	pass # Replace with function body.

func _pick_up(player: Player):
	owning_player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_charging && can_fire && firing && (infinite_ammo || current_uses > 0)):
		charge_timer -= delta
		if(charge_timer < 0 && is_automatic):
			_tell_joke()
	if(!can_fire && is_automatic && delay_timer > 0):
		#print(can_fire, " ", delay_timer)
		delay_timer -= delta
		if(delay_timer <= 0):
			#delay_timer = fire_delay;
			can_fire = true
			#print("can fire auto again")
	if(!is_automatic && delay_timer > 0):
		delay_timer -= delta
	if(is_automatic && firing && can_fire && (infinite_ammo || current_uses > 0)):
		_tell_joke()
	pass

func _set_heading(heading: Vector2, position: Vector2):
	current_heading = heading;

func _tell_joke():
	#print("tell joke " + text_name)
	if(!can_fire || (!infinite_ammo && current_uses <=0) || delay_timer > 0):
		#print("can't fire: ", can_fire, infinite_ammo, current_uses, delay_timer, fire_delay)
		return;
	for i in num_bullets:
		var projectile = BASE_PROJECTILE.instantiate() as Projectile
		var proj_heading = current_heading
		if(spread > 0):
			if(use_random_spread):
				proj_heading = current_heading.rotated(deg_to_rad(randf_range(-spread,spread)))
			else:
				proj_heading = current_heading.rotated(deg_to_rad(-spread + (((2 * spread)/(num_bullets+1))*(i+1))))
		
		if projectile:
			projectile._setup_bullet(projectile_name, proj_heading)
			projectile.global_position = owning_player.global_position
			owning_player.get_parent().add_child(projectile)
		
	if(!infinite_ammo):
		current_uses -= 1
	
	delay_timer = fire_delay
	
	#if(!is_automatic):
	can_fire = false
		
	if(is_charging):
		charge_timer = charge_delay
	pass

func _start_telling_joke():
	if(firing || !can_fire || (!infinite_ammo && current_uses <= 0)):
		return
	
	firing = true
	
	if(is_automatic || is_charging):
		return
	
	if(delay_timer <= 0):
		#print("firing with delay timer at " , delay_timer , " of " , fire_delay)
		_tell_joke()
	else:
		#print("firing under cooldown: " , delay_timer, " of ", fire_delay)
		pass


func _stop_telling_joke(unequip: bool = false):
	if(is_charging && !is_automatic):
		if(charge_timer < 0 && !unequip):
			_tell_joke()
		else:
			charge_timer = charge_delay
	
	if(!is_automatic):
		can_fire = true;
	firing = false;
	pass
	
func _restore_uses(percentage: float):
	var ammo_restore = (int)(max_uses * percentage)
	current_uses = min(current_uses + ammo_restore, max_uses)

