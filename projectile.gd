class_name Projectile
extends CharacterBody2D

enum OnHit{BREAK,BOUNCE,SPLIT,EXPLODE, PIERCE}
enum MoveType{STANDARD, TRAP, ACCELERATE}

@export var speed: float
@export var damage: int
@export var despawn_time: float
var lifespan: float
@export var on_enemy_hit: OnHit
@export var on_wall_hit: OnHit
@export var on_timer_end: OnHit
@export var piercing_max: int
var piercing_count: int
@export var max_bounces: int
@export var split_projectile: Projectile
@export var num_split_projectiles: int
@export var explode_radius: float
@export var move_type: MoveType
@export var acceleration: float
var heading = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	lifespan = despawn_time
	piercing_count = piercing_max
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(move_type == MoveType.ACCELERATE):
		speed = speed * (1 + (acceleration * delta))
		
	velocity = heading.normalized() * speed;
	
	move_and_slide()
	lifespan -= delta
	if(lifespan < 0):
		_on_timer_end()
	pass
	
func _hit_wall():
	match on_wall_hit:
		OnHit.BREAK:
			queue_free()
		OnHit.BOUNCE:
			#bounce
			pass
		OnHit.SPLIT:
			#spawn new projectiles
			pass
		OnHit.EXPLODE:
			#explode
			pass
		OnHit.PIERCE:
			piercing_count-=1
			if(piercing_count < 0):
				queue_free()
				
func _hit_enemy():
	#deal damage
	match on_wall_hit:
		OnHit.BREAK:
			queue_free()
		OnHit.BOUNCE:
			#bounce
			pass
		OnHit.SPLIT:
			#spawn new projectiles
			pass
		OnHit.EXPLODE:
			#explode
			pass
		OnHit.PIERCE:
			piercing_count-=1
			if(piercing_count < 0):
				queue_free()
		
func _on_timer_end():
	match on_timer_end:
		OnHit.BREAK:
			queue_free()
		OnHit.BOUNCE:
			queue_free()
		OnHit.SPLIT:
			#spawn new projectiles
			pass
		OnHit.EXPLODE:
			#explode
			pass
		OnHit.PIERCE:
			queue_free()
