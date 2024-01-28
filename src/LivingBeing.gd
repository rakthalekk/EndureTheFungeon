class_name LivingBeing
extends CharacterBody2D

@export var max_haha_points: int
var current_haha_points: int
@export var i_frames: float
var i_timer: float

var sprite: Sprite2D
var dead = false

var dodging = false

var hurt_sound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	current_haha_points = max_haha_points
	
	hurt_sound = get_node("HurtSound")


func _take_damage(damage: int):
	if(dead):
		return
	if i_timer > 0 || dodging:
		#print("i frames active")
		return;
	
	hurt_sound.play()
	#print("took ",damage," damage. Hahas at ",current_haha_points, " of ", max_haha_points)
	current_haha_points -= damage;
	i_timer = i_frames

	if current_haha_points <= 0:
		_no_more_laughing()
	
	var anim = get_node("EffectsAnimation") as AnimationPlayer
	if anim:
		anim.play("hurt")


func _heal(healing: int, ignore_max: bool = false):
	if(dead):
		return
	print("healed by ", healing)
	current_haha_points = min(max_haha_points, current_haha_points + healing)


func _increase_health_max(max_haha_boost: int, heal: bool = true):
	max_haha_points += max_haha_boost
	if(heal):
		_heal(max_haha_boost)


func _decrease_health_max(max_haha_hit: int, damage: bool = false):
	max_haha_points -= max_haha_hit
	if(damage):
		_take_damage(max_haha_hit)
	if(current_haha_points > max_haha_points):
		current_haha_points = max_haha_points


func _no_more_laughing():
	dead = true
	queue_free()
