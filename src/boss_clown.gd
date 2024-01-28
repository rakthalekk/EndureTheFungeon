class_name BossClown
extends Enemy


func single():
	for i in range(3):
		for j in range(10):
			fire_direction = (player.global_position - global_position).normalized()
			make_bullet("BossTriple")
			await get_tree().create_timer(0.1).timeout
		
		for j in range(5):
			fire_direction = (player.global_position - global_position).normalized()
			make_bullet("BossTriple")
			await get_tree().create_timer(0.3).timeout
		
	await get_tree().create_timer(1).timeout


func burst():
	for i in range(20):
		fire_direction = (player.global_position - global_position).normalized()
		fire_direction = fire_direction.rotated(deg_to_rad(90))
		
		for j in range(5):
			fire_direction = fire_direction.rotated(deg_to_rad(-30))
			make_bullet("BossBurst")
	
		await get_tree().create_timer(0.3).timeout
	
	await get_tree().create_timer(2).timeout


func sweep():
	arc()
	await get_tree().create_timer(1.2).timeout
	arc()
	await get_tree().create_timer(1.2).timeout
	arc()
	await get_tree().create_timer(3).timeout


func arc():
	var fire_direction1 = Vector2(-1, 0)
	var fire_direction2 = Vector2(1, 0)
	for i in range(12):
		fire_direction1 = fire_direction1.rotated(deg_to_rad(-15))
		fire_direction2 = fire_direction2.rotated(deg_to_rad(15))
		
		fire_direction = fire_direction1
		make_bullet("BossSweep")
		
		fire_direction = fire_direction2
		make_bullet("BossSweep")
		await get_tree().create_timer(.2).timeout


func split():
	for i in range(5):
		fire_direction = (player.global_position - global_position).normalized()
		make_bullet("BossSplit")
		await get_tree().create_timer(1).timeout
	
	await get_tree().create_timer(2).timeout


func wavy():
	for i in range(50):
		fire_direction = Vector2(2, 1).normalized().rotated(deg_to_rad(randi_range(0, 120)))
		make_bullet("BossWavy")
		await get_tree().create_timer(.15).timeout
	
	get_tree().create_timer(2).timeout


func wiggly():
	for i in range(5):
		fire_direction = Vector2(1, 0)
		make_bullet("BossWiggly")
		
		for j in range(6):
			fire_direction = fire_direction.rotated(deg_to_rad(30))
			make_bullet("BossWiggly")
		
		await get_tree().create_timer(0.5).timeout
		
		fire_direction = Vector2(1, 0).rotated(deg_to_rad(15))
		make_bullet("BossWiggly")
		
		for j in range(5):
			fire_direction = fire_direction.rotated(deg_to_rad(30))
			make_bullet("BossWiggly")
	
		await get_tree().create_timer(0.5).timeout
	
	await get_tree().create_timer(2).timeout


func bouncy():
	for i in range(40):
		fire_direction = Vector2(2, 1).normalized().rotated(deg_to_rad(randi_range(0, 120)))
		make_bullet("BossBouncy")
		await get_tree().create_timer(.15).timeout
	
	await get_tree().create_timer(4).timeout


func get_random_attack():
	var random = randi_range(1, 7)
	match random:
		1:
			await single()
		2:
			await burst()
		3:
			await sweep()
		4:
			await split()
		5:
			await bouncy()
		6:
			await wiggly()
		7:
			await wavy()


func make_bullet(bullet_name: String):
	var bullet = BULLET.instantiate() as EnemyBullet
	bullet.global_position = global_position
	bullet._setup_bullet(bullet_name, fire_direction)
	get_tree().root.add_child(bullet)


func _no_more_laughing():
	get_tree().change_scene_to_file("res://src/win_screen.tscn")


func _on_start_timer_timeout():
	await single()
	await burst()
	await sweep()
	await split()
	await bouncy()
	await wiggly()
	await wavy()
	
	while true:
		await get_random_attack()
