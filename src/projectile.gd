class_name Projectile
extends CharacterBody2D

var data: ProjectileData

@export var projectile_name: String

@export var hitbox: Area2D

var speed: int

var heading := Vector2.ZERO
var lifespan: float
var piercing_count: int

# Called when the node enters the scene tree for the first time.
func _ready():
	data = ProjectileDatabase.get_projectile_data(projectile_name)
	
	lifespan = data.despawn_time
	piercing_count = data.piercing_max
	speed = data.speed
	
	hitbox.body_entered.connect(_hit_enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if data.move_type == ProjectileData.MoveType.ACCELERATE:
		speed = speed * (1 + (data.acceleration * delta))
		
	velocity = heading.normalized() * speed
	
	move_and_slide()
	
	lifespan -= delta
	if(lifespan < 0):
		_on_timer_end()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		_hit_wall()


func _hit_wall():
	match data.on_wall_hit:
		ProjectileData.OnHit.BREAK:
			queue_free()
		ProjectileData.OnHit.BOUNCE:
			#bounce
			pass
		ProjectileData.OnHit.SPLIT:
			#spawn new projectiles
			pass
		ProjectileData.OnHit.EXPLODE:
			#explode
			pass
		ProjectileData.OnHit.PIERCE:
			piercing_count -= 1
			if(piercing_count < 0):
				queue_free()


func _hit_enemy(enemy: CharacterBody2D):
	#deal damage
	match data.on_wall_hit:
		ProjectileData.OnHit.BREAK:
			queue_free()
		ProjectileData.OnHit.BOUNCE:
			#bounce
			pass
		ProjectileData.OnHit.SPLIT:
			#spawn new projectiles
			pass
		ProjectileData.OnHit.EXPLODE:
			#explode
			pass
		ProjectileData.OnHit.PIERCE:
			piercing_count -= 1
			if(piercing_count < 0):
				queue_free()


func _on_timer_end():
	match data.on_timer_end:
		ProjectileData.OnHit.BREAK:
			queue_free()
		ProjectileData.OnHit.BOUNCE:
			queue_free()
		ProjectileData.OnHit.SPLIT:
			#spawn new projectiles
			pass
		ProjectileData.OnHit.EXPLODE:
			#explode
			pass
		ProjectileData.OnHit.PIERCE:
			queue_free()
