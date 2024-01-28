extends Control

var mainLabel: Label
var prevLabel: Label
var nextLabel: Label

func _ready():
	Signals.ChangedWeapon.connect(UpdateRevolver)
	
	mainLabel = get_node("MainLabel/MainLabel")
	prevLabel = get_node("PrevLabel/PrevLabel")
	nextLabel = get_node("NextLabel/NextLabel")

func UpdateRevolver(player: Player):
	var prev = player._get_previous_joke()
	var next = player._get_next_joke()
	var curr = player.jokes[player.current_joke]
		
	prevLabel.text = prev.text_name
	nextLabel.text = next.text_name
	mainLabel.text = curr.text_name
