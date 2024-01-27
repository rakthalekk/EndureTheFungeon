extends CharacterBody2D
var heading = Vector2.ZERO;

const SPEED = 300.0

func _process(delta):
	var mousePos = get_global_mouse_position();
	heading = mousePos - global_position;

func _physics_process(delta):
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	velocity = direction * SPEED
	
	move_and_slide()
