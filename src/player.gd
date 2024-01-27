class_name Player
extends LivingBeing

const MOUSE_RETICLE = preload("res://src/bullet_reticle.tscn")

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

func _process(delta):
	var mousePos = get_global_mouse_position();
	heading = mousePos - global_position;
	jokes[current_joke]._set_heading(heading, global_position)
	if(i_timer > 0):
		i_timer -= delta;

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	velocity = direction * SPEED
	
	if(Input.is_action_just_pressed("shoot")):
		jokes[current_joke]._start_telling_joke()
		print("shooting")
	if(Input.is_action_just_released("shoot")):
		jokes[current_joke]._stop_telling_joke()
		print("no longer shooting")
	
	move_and_slide()
	
	


func _no_more_laughing():
	#call game over
	pass

func _learn_joke(new_joke: Joke):
	if(joke_names.find(new_joke.text_name) == -1):
		joke_names.append(new_joke.text_name)
		jokes.append(new_joke)
		new_joke._pick_up(self)

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
