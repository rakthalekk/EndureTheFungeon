extends Node
@export var laugh: Joke
var used_jokes: Array[String]
var new_jokes: Array[String]

func _ready():
	var nodes = get_children()
	for node in nodes:
		var joke = node as Joke
		new_jokes.append(joke.name)
	var i = new_jokes.find(laugh.name)
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
	print("jokes: ", new_jokes.size())
	return new_jokes.size() > 0

func _has_old_jokes(): 
	return used_jokes.size() > 0

func _get_random_old_joke():
	print("old! (end)")
	if(_has_old_jokes()):
		print("old! (success)")
		return _get_joke(used_jokes.pick_random())
	else:
		print("kiddo")
		return get_children().pick_random().name

func _get_random_new_joke():
	if(_has_new_jokes()):
		print("new!")
		return _get_joke(new_jokes.pick_random())
	else:
		print("old! (out)")
		return _get_random_old_joke()
