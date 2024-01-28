class_name Player
extends LivingBeing

const MOUSE_RETICLE = preload("res://src/bullet_reticle.tscn")

const LEFT_SPRITE = preload("res://Assets/Character/Player/Main_Character_Walk_Cycle_Leftt.png")
const RIGHT_SPRITE = preload("res://Assets/Character/Player/Main_Character_Walk_Cycle_Right.png")

var direction = Vector2.ZERO

var heading = Vector2.ZERO;

var jokes: Array[Joke]
var joke_names: Array[String]
var current_joke: int

const SPEED = 700.0

func _ready():
	#MOUSE_RETICLE.instantiate()
	jokes.append(JokeDatabase._get_laugh());
	joke_names.append(jokes[0].text_name)
	jokes[0]._pick_up(self)
	current_joke = 0;
	sprite = get_node("Sprite2D")
	print("hp: " , max_haha_points , ", i: " , i_frames)

func _process(delta):
	var mousePos = get_global_mouse_position();
	heading = mousePos - global_position;
	jokes[current_joke]._set_heading(heading, global_position)
	if(i_timer > 0):
		print("i frames: ", i_timer)
		i_timer -= delta;
	
	if direction.x > 0:
		$Sprite2D.texture = RIGHT_SPRITE
		$AnimationPlayer.play("walk")
	elif direction.x < 0:
		$Sprite2D.texture = LEFT_SPRITE
		$AnimationPlayer.play("walk")
	elif direction.y != 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")


func _physics_process(delta):
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	velocity = direction * SPEED
	
	if(Input.is_action_just_pressed("shoot")):
		jokes[current_joke]._start_telling_joke()
		#print("shooting")
	if(Input.is_action_just_released("shoot")):
		jokes[current_joke]._stop_telling_joke()
		#print("no longer shooting")
	if(Input.is_action_just_pressed("next_weapon")):
		_next_joke()
		print("next weapon")
	if(Input.is_action_just_pressed("prev_weapon")):
		_prev_joke()
		print("prev weapon")
		
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if(collider is Pickup):
			_handle_pickup(collider as Pickup)


func _no_more_laughing():
	print("player is sad")
	pass


func _learn_joke(new_joke: Joke):
	if(joke_names.find(new_joke.text_name) == -1):
		joke_names.append(new_joke.text_name)
		jokes.append(new_joke)
		new_joke._pick_up(self)
		print("learned new joke: ", new_joke.text_name)
	


func _next_joke():
	jokes[current_joke]._stop_telling_joke(true)
	current_joke += 1
	if(current_joke >= jokes.size()):
		current_joke = 0;
	#change visual displays to match new joke
	if(Input.is_action_pressed("shoot")):
		jokes[current_joke]._start_telling_joke()

func _prev_joke():
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
			print("trying to learn joke")
			_learn_joke(JokeDatabase._get_joke(pickup.joke_name))
		else:
			print("trying to restore joke uses")
			jokes[joke_id]._restore_uses(pickup.joke_restore_amount)
	else:
		return
	pickup._consume()
	
