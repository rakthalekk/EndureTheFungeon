class_name Projectile
extends CharacterBody2D

var data: ProjectileData

var BULLET = load("res://src/projectile.tscn")
var EXPLOSION = load("res://src/explosion.tscn")

@export var projectile_name: String

var hitbox: Area2D
var sprite: Sprite2D

var speed: float

var heading := Vector2.ZERO
var lifespan: float
var piercing_count: int


# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_things()
	
	if(hitbox):
		hitbox.body_entered.connect(_projectile_hit)
	else:
		print("NO HITBOX ASSIGNED. PLEASE FIX")


func initialize_things():
	if !hitbox:
		hitbox = get_node("Hitbox")
	
	if !sprite:
		sprite = get_node("Sprite2D")


func _setup_bullet(bullet_name: String, newHeading: Vector2):
	initialize_things()
	
	data = ProjectileDatabase.get_projectile_data(bullet_name)
	lifespan = data.despawn_time
	piercing_count = data.piercing_max
	speed = data.speed
	heading = newHeading
	hitbox.scale = Vector2(data.bullet_radius,data.bullet_radius)
	sprite.scale = Vector2(data.bullet_radius,data.bullet_radius)
	#print("setup " , bullet_name , " with lifespan ", lifespan)


func _setup_bullet_data(bullet_data: ProjectileData, newHeading: Vector2):
	initialize_things()
	
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
	elif(data.move_type == ProjectileData.MoveType.TRAP):
		speed = lerpf(data.speed, 0.0, min(1, (data.despawn_time - lifespan) / data.trap_move_time))
	elif(data.move_type == ProjectileData.MoveType.DIRECTSINE):
		speed = data.speed * (.5 * sin((data.despawn_time - lifespan) * data.sine_frequency / (2 * PI)) + .5)
	
	velocity = heading.normalized() * speed
	
	if(data.move_type == ProjectileData.MoveType.LATERALSINE):
		velocity += velocity.rotated(PI/2).normalized() * data.sine_amplitude * sin((data.despawn_time - lifespan) *data.sine_frequency / (2*PI))
	move_and_slide()
	
	
	if(data.align_to_heading):
		look_at(global_position + heading)
	
	lifespan -= delta
	if(lifespan < 0):
		_on_timer_end()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is LivingBeing:
			_hit_enemy(collider)
		else:
			_hit_wall(collider)
		
		if data.on_wall_hit == ProjectileData.OnHit.BOUNCE:
			heading = heading.bounce(collision.get_normal())


func _hit_wall(body):
	match data.on_wall_hit:
		ProjectileData.OnHit.BREAK:
			queue_free()
		ProjectileData.OnHit.BOUNCE:
			pass
		ProjectileData.OnHit.SPLIT:
			spawn_split_projectiles()
		ProjectileData.OnHit.EXPLODE:
			_spawn_explosion()
			queue_free()
			pass
		ProjectileData.OnHit.PIERCE:
			piercing_count -= 1
			if(piercing_count < 0):
				queue_free()


func _hit_enemy(enemy: CharacterBody2D):
	var enemyBody = enemy as Enemy
	enemyBody._take_damage(data.damage)
	match data.on_enemy_hit:
		ProjectileData.OnHit.BREAK:
			queue_free()
		ProjectileData.OnHit.BOUNCE:
			#bounce
			pass
		ProjectileData.OnHit.SPLIT:
			spawn_split_projectiles()
		ProjectileData.OnHit.EXPLODE:
			_spawn_explosion()
			queue_free()
			pass
		ProjectileData.OnHit.PIERCE:
			piercing_count -= 1
			if(piercing_count < 0):
				queue_free()


func spawn_split_projectiles():
	var split_direction = heading
	var degree_delta = data.split_angle / data.num_split_projectiles
	
	split_direction = split_direction.rotated(deg_to_rad(-degree_delta * data.num_split_projectiles / 2.0))
	
	for i in data.num_split_projectiles:
		var bullet = BULLET.instantiate() as EnemyBullet
		bullet.global_position = global_position
		bullet._setup_bullet(data.split_projectile, split_direction)
		get_parent().add_child(bullet)
		
		split_direction = split_direction.rotated(deg_to_rad(degree_delta))
	
	queue_free()

func _spawn_explosion():
	
	var explosion = EXPLOSION.instantiate() as Projectile
	
	explosion._setup_bullet(data.explosion_projectile, heading)
	explosion.scale = Vector2(data.explode_radius, data.explode_radius)
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	#print("explode", explosion, ", " , explosion.scale)

func _on_timer_end():
	#print(projectile_name, " out of time")
	match data.on_timer_end:
		ProjectileData.OnHit.BREAK:
			queue_free()
		ProjectileData.OnHit.BOUNCE:
			queue_free()
		ProjectileData.OnHit.SPLIT:
			spawn_split_projectiles()
		ProjectileData.OnHit.EXPLODE:
			_spawn_explosion()
			queue_free()
			pass
		ProjectileData.OnHit.PIERCE:
			queue_free()


func _projectile_hit(body):
	if(body is Enemy):
		_hit_enemy(body)
	else:
		_hit_wall(body)
