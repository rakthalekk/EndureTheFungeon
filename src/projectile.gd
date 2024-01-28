class_name Projectile
extends CharacterBody2D

var data: ProjectileData

@export var projectile_name: String

@export var hitbox: Area2D
@export var sprite: Sprite2D

var speed: int

var heading := Vector2.ZERO
var lifespan: float
var piercing_count: int



# Called when the node enters the scene tree for the first time.
func _ready():
	print("setup")
	if(hitbox):
		hitbox.body_entered.connect(_projectile_hit)
	else:
		print("NO HITBOX ASSIGNED. PLEASE FIX")
	print("setup complete")

func _setup_bullet(bullet_name: String, newHeading: Vector2):
	data = ProjectileDatabase.get_projectile_data(bullet_name)
	lifespan = data.despawn_time
	piercing_count = data.piercing_max
	speed = data.speed
	heading = newHeading
	hitbox.scale = Vector2(data.bullet_radius,data.bullet_radius)
	sprite.scale = Vector2(data.bullet_radius,data.bullet_radius)
	print("finished setting up bullet " + bullet_name)
	
func _setup_bullet_data(bullet_data: ProjectileData, newHeading: Vector2):
	data = bullet_data
	lifespan = data.despawn_time
	piercing_count = data.piercing_max
	speed = data.speed
	heading = newHeading
	sprite.scale = Vector2(data.bullet_radius,data.bullet_radius)
	hitbox.scale = Vector2(data.bullet_radius,data.bullet_radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(data == null):
		print("DATA IS NULL")
		return
	if(data.move_type == ProjectileData.MoveType.ACCELERATE):
		speed = speed * (1 + (data.acceleration * delta))
		
	velocity = heading.normalized() * speed
	
	move_and_slide()
	
	lifespan -= delta
	if(lifespan < 0):
		_on_timer_end()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if(collider is Enemy):
			_hit_enemy(collider)
		else:
			_hit_wall(collider)


func _hit_wall(body):
	print("projectile hit wall")
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
	print("projectile hit enemy")
	var enemyBody = enemy as Enemy
	#deal damage
	enemyBody._take_damage(data.damage)
	match data.on_enemy_hit:
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
	print("projectile despawned")
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


func _projectile_hit(body):
	if(body is Enemy):
		_hit_enemy(body)
	else:
		_hit_wall(body)
