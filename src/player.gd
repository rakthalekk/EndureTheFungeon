class_name Player
extends LivingBeing

const MOUSE_RETICLE = preload("res://src/bullet_reticle.tscn")
const GAME_OVER = preload("res://src/game_over.tscn")
const YOU_WIN = preload("res://src/you_win.tscn")

var direction = Vector2.ZERO

var heading = Vector2.ZERO

var facing = "left"

var can_dodge = true

var can_move = true

var jokes: Array[Joke]
var joke_names: Array[String]
var current_joke: int

const SPEED = 700.0

func _ready():
	#MOUSE_RETICLE.instantiate()
	super()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	jokes.append(JokeDatabase._get_laugh());
	joke_names.append(jokes[0].text_name)
	jokes[0]._pick_up(self)
	current_joke = 0;
	sprite = get_node("Sprite2D")
	print("hp: " , max_haha_points , ", i: " , i_frames, " jokes: " , jokes.size())

func _process(delta):
	#super(delta)
	if dead:
		return
	var mousePos = get_global_mouse_position();
	heading = mousePos - global_position;
	jokes[current_joke]._set_heading(heading, global_position)
	if(i_timer > 0):
		#print("i frames: ", i_timer)
		i_timer -= delta;
	
	if direction.x > 0:
		facing = "right"
	elif direction.x < 0:
		facing = "left"
	var charge = get_node("Charge")
	if(jokes[current_joke].is_charging):
		charge.visible = true
		if(!jokes[current_joke].firing):
			charge.frame = 0
		elif(jokes[current_joke].charge_timer < 0):
			charge.frame = 10
		else:
			print((jokes[current_joke].charge_delay - jokes[current_joke].charge_timer) / jokes[current_joke].charge_delay)
			charge.frame = (int)(10 * (jokes[current_joke].charge_delay - jokes[current_joke].charge_timer) / jokes[current_joke].charge_delay)
	else:
		charge.visible = false
	
	var current_anim = $AnimationPlayer.current_animation
	if !dodging:
		if (current_anim == "throw_left" || current_anim == "throw_right") && $AnimationPlayer.is_playing():
			return
		
		if jokes[current_joke].firing:
			$AnimationPlayer.play("throw_" + facing)
		
		elif direction.length() > 0:
			$AnimationPlayer.play("walk_" + facing)
		else:
			$AnimationPlayer.play("idle_" + facing)


func _physics_process(delta):
	if dead:
		return
	if !dodging:
		direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
		
		if !dodging && Input.is_action_just_pressed("dodge") && can_dodge:
			dodging = true
			$AnimationPlayer.play("dodge")
		
		if(Input.is_action_just_pressed("shoot")):
			jokes[current_joke]._start_telling_joke()

		if(Input.is_action_just_released("shoot")):
			jokes[current_joke]._stop_telling_joke()

		if(Input.is_action_just_pressed("next_weapon")):
			_next_joke()

		if(Input.is_action_just_pressed("prev_weapon")):
			_prev_joke()
	
	velocity = direction * SPEED
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if(collider is Pickup):
			_handle_pickup(collider as Pickup)


func end_dodge():
	dodging = false
	can_dodge = false
	$DodgeCooldown.start()


func _no_more_laughing():
	if dead:
		return
	
	dead = true

	$EffectsAnimation.play("RESET")
	$AnimationPlayer.play("RESET")
	
	await get_tree().create_timer(.01).timeout
	
	$AnimationPlayer.play("dead")
	
	await get_tree().create_timer(2).timeout
	
	get_tree().change_scene_to_file("res://src/game_over.tscn")


func _learn_joke(new_joke: Joke):
	if(joke_names.find(new_joke.text_name) == -1):
		joke_names.append(new_joke.text_name)
		jokes.append(new_joke)
		new_joke._pick_up(self)
		print("learned new joke: ", new_joke.text_name)


func _next_joke():
	print("next joke")
	jokes[current_joke]._stop_telling_joke(true)
	print(current_joke)
	current_joke += 1
	print(current_joke)
	if(current_joke >= jokes.size()):
		#print(current_joke, " higher than ", jokes.size())
		current_joke = 0;
	#change visual displays to match new joke
	if(Input.is_action_pressed("shoot")):
		jokes[current_joke]._start_telling_joke()


func _prev_joke():
	print("prev joke")
	jokes[current_joke]._stop_telling_joke(true)
	current_joke -= 1
	if(current_joke < 0):
		current_joke = jokes.size() - 1;
	#change visual displays to match new joke
	if(Input.is_action_pressed("shoot")):
		jokes[current_joke]._start_telling_joke()


func _handle_pickup(pickup: Pickup):
	if(pickup.used):
		return
	pickup._use()
	if(pickup.pickup_type == pickup.PickupType.HEALTH):
		_heal(pickup.heal_amount)
	elif(pickup.pickup_type == pickup.PickupType.JOKE):
		var joke_id = joke_names.find(pickup.joke_name);
		if(joke_id == -1):
			print("learning ", pickup.joke_name)
			_learn_joke(JokeDatabase._get_joke(pickup.joke_name))
			print("trying to learn joke. now at ", jokes.size())
		else:
			jokes[joke_id]._restore_uses(pickup.joke_restore_amount)
	else:
		return
	pickup._consume()


func _win_game():
	can_move = false
	var you_win = YOU_WIN.instantiate()
	get_parent().add_child(you_win)


func _on_dodge_cooldown_timeout():
	can_dodge = true
