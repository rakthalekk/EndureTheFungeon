extends Control

var HPbar: ProgressBar
var FPbar: ProgressBar
var player: Player

func _ready():
	HPbar = get_node("HPbar")
	FPbar = get_node("FPbar")
	
	Signals.ChangedWeapon.connect(UpdateJoke)

func _process(delta):
	if player == null:
		return
	
	HPbar.max_value = player.max_haha_points
	HPbar.value = player.current_haha_points

func UpdateJoke(player: Player):
	FPbar.value = player.jokes[player.current_joke].current_uses
	FPbar.max_value = player.jokes[player.current_joke].max_uses
