extends CharacterBody2D


const SPEED = 50.0

const BULLET = preload("res://src/enemy_bullet.tscn")

var player: CharacterBody2D
var direction: Vector2

var fire_direction: Vector2

var move_patterns = ["Approach", "Flee", "Strafe"]
var move_pattern = move_patterns.pick_random()

var fire_patterns = ["Direct", "Spiral"]
var fire_pattern = fire_patterns.pick_random()


func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	if move_pattern == "Strafe":
		$WanderTimer.start(randf_range(1, 2))
		direction = Vector2(1, 0)
	
	if fire_pattern == "Spiral":
		fire_direction = Vector2(0, 1)
		$ShootTimer.start(0.5)


func _physics_process(delta):
	movement()
	
	velocity = direction * SPEED

	move_and_slide()


func movement():
	match move_pattern:
		"Approach":
			direction = (player.global_position - global_position).normalized()
		"Flee":
			direction = (global_position - player.global_position).normalized()
		"Strafe":
			pass


func shoot():
	match fire_pattern:
		"Direct":
			fire_direction = (player.global_position - global_position).normalized()
			$ShootTimer.start(1)
		"Spiral":
			fire_direction = fire_direction.rotated(deg_to_rad(45))
			$ShootTimer.start(0.5)
	
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
	direction = -direction
	$WanderTimer.start(randf_range(1, 2))
