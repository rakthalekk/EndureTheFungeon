class_name EnemyBullet
extends Projectile


func _ready():
	BULLET = load("res://src/enemy_bullet.tscn")
	
	var s = SOUND.instantiate() 
	get_tree().root.add_child(s)
	s.play_sound(sound)


func _on_timer_timeout():
	queue_free()


func _on_hitbox_body_entered(body):
	if body is Player:
		body._take_damage(data.damage)
