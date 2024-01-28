extends Node

@export var healthPickups: Array[String]
@export var healAmount: int
@export var jokeChance: float
@export var jokePickupRestoreAmount: float

const BASE_JOKE_PICKUP = preload("res://src/pickup.tscn")
const BASE_HEALTH_PICKUP = preload("res://src/pickup.tscn")

func _get_pickup(pickup_name : String) -> Pickup:
	return get_node(pickup_name);
	
func _get_minor_reward() -> Pickup:
	var random = randf();
	if(random < jokeChance && JokeDatabase._has_old_jokes()):
		var joke_pickup = BASE_JOKE_PICKUP.instantiate()
		joke_pickup.pickup_type = Pickup.PickupType.JOKE
		joke_pickup.joke_restore_amount = jokePickupRestoreAmount
		joke_pickup.joke_name = JokeDatabase._get_random_old_joke()
		return joke_pickup
	else:
		var health_pickup = BASE_HEALTH_PICKUP.instantiate()
		health_pickup.pickup_type = Pickup.PickupType.HEALTH
		health_pickup.heal_amount = healAmount
		return health_pickup
	
func _get_major_reward() -> Pickup:
	var random = randf();
	if(JokeDatabase._has_new_jokes()):
		var joke_pickup = BASE_JOKE_PICKUP.instantiate()
		joke_pickup.pickup_type = Pickup.PickupType.JOKE
		joke_pickup.joke_restore_amount = jokePickupRestoreAmount
		joke_pickup.joke_name = JokeDatabase._get_random_new_joke().text_name
		return joke_pickup
	else:
		return _get_minor_reward()
	
