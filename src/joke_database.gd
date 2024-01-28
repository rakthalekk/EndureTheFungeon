extends Node
@export var laugh: Joke
var used_jokes: Array[String]
var new_jokes: Array[String]

func _ready():
	var nodes = get_children()
	for node in nodes:
		var joke = node as Joke
		new_jokes.append(joke.text_name)
	var i = new_jokes.find(laugh.text_name)
	if(i != -1):
		new_jokes.remove_at(i)

func _get_joke(joke_name : String) -> Joke:
	return get_node(joke_name);

func _get_laugh() -> Joke:
	return laugh;
	
func _use_joke(joke_name: String):
	var i = new_jokes.find(joke_name)
	if(i != -1):
		new_jokes.remove_at(i);
		used_jokes.append(joke_name);

func _has_new_jokes(): 
	return new_jokes.size() > 0

func _has_old_jokes(): 
	return used_jokes.size() > 0

func _get_random_old_joke():
	if(_has_old_jokes()):
		return _get_joke(used_jokes.pick_random())

func _get_random_new_joke():
	if(_has_new_jokes()):
		return _get_joke(new_jokes.pick_random())
