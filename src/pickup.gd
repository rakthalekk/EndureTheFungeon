class_name Pickup
extends StaticBody2D

enum PickupType{HEALTH, JOKE}

@export var pickup_type: PickupType
@export var joke_name: String
@export var heal_amount: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
