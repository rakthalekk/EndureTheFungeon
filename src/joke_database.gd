extends Node
@export var laugh: Joke


func _get_joke(name : String) -> Joke:
	return get_node(name);

func _get_laugh() -> Joke:
	return laugh;
