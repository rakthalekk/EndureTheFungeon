class_name Pickup
extends StaticBody2D

enum PickupType{HEALTH, JOKE}

@export var pickup_type: PickupType
@export var joke_name: String
@export var joke_restore_amount: float
@export var heal_amount: int 

var used = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _use():
	used = true

func _consume():
	queue_free()
