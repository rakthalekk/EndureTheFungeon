extends AnimationPlayer

@export var anim_time: float
var timer: float
# Called when the node enters the scene tree for the first time.
func _ready():
	print("explosion starts")
	play("explode")
	timer = anim_time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer-=delta
