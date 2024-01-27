extends CharacterBody2D


const SPEED = 50.0

const BULLET = preload("res://src/enemy_bullet.tscn")

var player: CharacterBody2D
var direction: Vector2


func _ready():
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta):
	if is_instance_valid(player):
		direction = (player.global_position - global_position).normalized()
	
	velocity = direction * SPEED

	move_and_slide()


func _on_hitbox_body_entered(body):
	if body is CharacterBody2D:
		body.queue_free()


func _on_timer_timeout():
	var bullet = BULLET.instantiate() as EnemyBullet
	bullet.global_position = global_position
	bullet.initialize(direction, 300, 1)
	get_parent().add_child(bullet)
