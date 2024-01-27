extends Node
@export var laugh: Joke


func _get_joke(joke_name : String) -> Joke:
	return get_node(joke_name);

func _get_laugh() -> Joke:
	return laugh;
