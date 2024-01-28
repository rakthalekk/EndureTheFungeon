class_name Pickup
extends StaticBody2D

enum PickupType{HEALTH, JOKE}

@export var pickup_type: PickupType
@export var joke_name: String
@export var joke_restore_amount: float
@export var heal_amount: int 

var used = false

var sprite: Sprite2D
var animatedSprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite2D")
	animatedSprite = get_node("AnimatedSprite2D")
	
	sprite.visible = true
	animatedSprite.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _use():
	used = true

func _consume():
	sprite.visible = false
	animatedSprite.visible = true
	
	animatedSprite.play("splat")
	
	var timer = get_tree().create_timer(0.6)
	#timer.start(0)
	await timer.timeout
	
	queue_free()
