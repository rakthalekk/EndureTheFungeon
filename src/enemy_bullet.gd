class_name EnemyBullet
extends Area2D



var direction: Vector2
var speed: int
var lifespan: int


func initialize(dir: Vector2, spd: int, life: float):
	direction = dir
	speed = spd
	lifespan = life


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body is CharacterBody2D:
		body.queue_free()
