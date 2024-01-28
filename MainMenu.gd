extends Control




func _on_button_pressed():
	var player = get_parent().get_node("Player") as Player
	if(!player):
		print("NO PLAYER FOUND. CRITICAL FAILURE")
		return
	player._start_game()
	hide()


func _on_quit_pressed():
	get_tree().quit()
