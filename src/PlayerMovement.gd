extends Area2D
@export var move_speed = 400;
var screen_size;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	screen_size = get_viewport_rect().size;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO;
	if Input.is_action_pressed("move_up"):
		velocity.y = 1;
	if Input.is_action_pressed("move_down"):
		velocity.y = -1;
	if Input.is_action_pressed("move_up"):
		velocity.x = 1;
	if Input.is_action_pressed("move_up"):
		velocity.x = -1;
	pass
