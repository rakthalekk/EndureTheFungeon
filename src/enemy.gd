class_name Enemy
extends LivingBeing


const BULLET = preload("res://src/enemy_bullet.tscn")

var data: EnemyData

var player: CharacterBody2D
var direction: Vector2

var fire_direction: Vector2

enum MoveType {APPROACH, FLEE, STRAFE, CRAWL}
enum ShootType {DIRECT, SPIRAL, SPREAD}

var move_pattern = MoveType.values().pick_random()
#var move_pattern = MoveType.CRAWL

var shoot_pattern = ShootType.values().pick_random()
#var shoot_pattern = ShootType.DIRECT


func _ready():
	player = get_tree().get_first_node_in_group("player")
	data = EnemyDatabase.get_enemy_data("Enemy")
	
	if move_pattern == MoveType.STRAFE:
		$WanderTimer.start(randf_range(1, 2))
		direction = Vector2(1, 0)
	elif move_pattern == MoveType.CRAWL:
		$WaitTimer.start(1)
	
	if shoot_pattern == ShootType.SPIRAL:
		fire_direction = Vector2(0, 1)
		$ShootTimer.start(0.5)


func _physics_process(delta):
	movement()
	
	velocity = direction * data.speed
	
	move_and_slide()


func movement():
	match move_pattern:
		MoveType.APPROACH:
			if global_position.distance_to(player.global_position) < data.nearby_distance:
				direction = (player.global_position - global_position).normalized()
			else:
				direction = Vector2.ZERO
		MoveType.FLEE:
			if global_position.distance_to(player.global_position) < data.nearby_distance:
				direction = (global_position - player.global_position).normalized()
			else:
				direction = Vector2.ZERO
		MoveType.STRAFE:
			pass
		MoveType.CRAWL:
			pass


func shoot():
	match shoot_pattern:
		ShootType.DIRECT:
			fire_direction = (player.global_position - global_position).normalized()
			$ShootTimer.start(0.7)
			create_bullet()
		ShootType.SPIRAL:
			fire_direction = fire_direction.rotated(deg_to_rad(30))
			$ShootTimer.start(0.3)
			create_bullet()
		ShootType.SPREAD:
			fire_direction = (player.global_position - global_position).normalized()
			create_bullet()
			fire_direction = fire_direction.rotated(deg_to_rad(20))
			create_bullet()
			fire_direction = fire_direction.rotated(deg_to_rad(-40))
			create_bullet()
			$ShootTimer.start(2)


func create_bullet():
	var bullet = BULLET.instantiate() as EnemyBullet
	bullet.global_position = global_position
	bullet.heading = fire_direction
	get_parent().add_child(bullet)


func _on_hitbox_body_entered(body):
	if body is Player:
		body._take_damage(1)


func _on_timer_timeout():
	shoot()


func _on_wander_timer_timeout():
	if move_pattern == MoveType.STRAFE:
		direction = -direction
		$WanderTimer.start(randf_range(1, 2))
	elif move_pattern == MoveType.CRAWL:
		direction = Vector2.ZERO
		$WaitTimer.start(randf_range(1, 2))


func _on_wait_timer_timeout():
	if global_position.distance_to(player.global_position) < data.nearby_distance:
		direction = (player.global_position - global_position).normalized()
	else:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	$WanderTimer.start(1)
