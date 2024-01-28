class_name BossClown
extends Enemy


func _process(delta):
	pass


func pattern1():
	await triple()
	await triple()
	await triple()


func triple():
	fire_direction = (player.global_position - global_position).normalized()
	make_bullet("BossBullet1")
	await get_tree().create_timer(0.3).timeout
	
	fire_direction = (player.global_position - global_position).normalized()
	make_bullet("BossBullet1")
	await get_tree().create_timer(0.3).timeout
	
	fire_direction = (player.global_position - global_position).normalized()
	make_bullet("BossBullet1")
	await get_tree().create_timer(1).timeout


func burst():
	fire_direction = (player.global_position - global_position).normalized()
	fire_direction = fire_direction.rotated(deg_to_rad(90))
	
	for i in range(5):
		fire_direction = fire_direction.rotated(deg_to_rad(-30))
		make_bullet("BossBullet2")
	
	await get_tree().create_timer(2).timeout


func sweep():
	fire_direction = Vector2(-1, 0)
	
	for i in range(12):
		fire_direction = fire_direction.rotated(deg_to_rad(-15))
		make_bullet("BossBullet2")
		await get_tree().create_timer(.2).timeout
	
	await get_tree().create_timer(2).timeout


func make_bullet(bullet_name: String):
	var bullet = BULLET.instantiate() as EnemyBullet
	bullet.global_position = global_position
	bullet._setup_bullet(bullet_name, fire_direction)
	get_parent().add_child(bullet)


func _on_start_timer_timeout():
	await pattern1()
	await sweep()
	await burst()
	await burst()
	await burst()
	await sweep()
