class_name Enemy
extends LivingBeing


const BULLET = preload("res://src/enemy_bullet.tscn")

@export var enemy_name := "Enemy"

var data: EnemyData

var player: Player

var direction: Vector2
var fire_direction: Vector2

var anim_player : AnimationPlayer


func _ready():
	super()
	player = get_tree().get_first_node_in_group("player")
	load_from_data(EnemyDatabase.get_enemy_data(enemy_name))
	
	assign_movement_type()


func load_from_data(enemy_data: EnemyData):
	data = enemy_data
	max_haha_points = enemy_data.max_haha_points
	i_frames = enemy_data.i_frames
	$Sprite2D.texture = enemy_data.texture
	$Sprite2D.hframes = enemy_data.hframes
	
	anim_player = enemy_data.get_node("AnimationPlayer").duplicate()
	add_child(anim_player)
	anim_player.play("active")


func _physics_process(delta):
	if i_timer > 0:
		i_timer -= delta
	
	movement()
	
	velocity = direction * data.speed
	
	move_and_slide()


func assign_movement_type():
	if data.move_pattern == EnemyData.MoveType.STRAFE:
		$WanderTimer.start(randf_range(1, 2))
		direction = Vector2(1, 0)
	elif data.move_pattern == EnemyData.MoveType.CRAWL:
		$WaitTimer.start(1)
	
	if data.shoot_pattern == EnemyData.ShootType.SPIRAL:
		fire_direction = Vector2(0, 1)
		$ShootTimer.start(0.5)


func movement():
	match data.move_pattern:
		EnemyData.MoveType.APPROACH:
			if global_position.distance_to(player.global_position) < data.nearby_distance:
				direction = (player.global_position - global_position).normalized()
			else:
				direction = Vector2.ZERO
		EnemyData.MoveType.FLEE:
			if global_position.distance_to(player.global_position) < data.nearby_distance:
				direction = (global_position - player.global_position).normalized()
			else:
				direction = Vector2.ZERO
		EnemyData.MoveType.STRAFE:
			pass
		EnemyData.MoveType.CRAWL:
			pass
		EnemyData.MoveType.IDLE:
			direction = Vector2.ZERO


func shoot():
	match data.shoot_pattern:
		EnemyData.ShootType.DIRECT:
			fire_direction = (player.global_position - global_position).normalized()
			$ShootTimer.start(0.7)
			create_bullet()
		EnemyData.ShootType.SPIRAL:
			fire_direction = fire_direction.rotated(deg_to_rad(30))
			$ShootTimer.start(0.3)
			create_bullet()
		EnemyData.ShootType.SPREAD:
			fire_direction = (player.global_position - global_position).normalized()
			create_bullet()
			fire_direction = fire_direction.rotated(deg_to_rad(20))
			create_bullet()
			fire_direction = fire_direction.rotated(deg_to_rad(-40))
			create_bullet()
			$ShootTimer.start(2)
		EnemyData.ShootType.NONE:
			pass


func create_bullet():
	var bullet = BULLET.instantiate() as EnemyBullet
	bullet.global_position = global_position
	bullet._setup_bullet("Basic", fire_direction)
	get_parent().add_child(bullet)


func _on_hitbox_body_entered(body):
	if body is Player:
		body._take_damage(1)


func _on_timer_timeout():
	shoot()


func _on_wander_timer_timeout():
	if data.move_pattern == EnemyData.MoveType.STRAFE:
		direction = -direction
		$WanderTimer.start(randf_range(1, 2))
	elif data.move_pattern == EnemyData.MoveType.CRAWL:
		direction = Vector2.ZERO
		$WaitTimer.start(randf_range(1, 2))


func _on_wait_timer_timeout():
	if global_position.distance_to(player.global_position) < data.nearby_distance:
		direction = (player.global_position - global_position).normalized()
	else:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	$WanderTimer.start(1)
