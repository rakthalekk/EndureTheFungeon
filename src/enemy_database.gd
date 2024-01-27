extends Node2D


func _ready():
	hide()


func get_enemy_data(e_name: String) -> EnemyData:
	return get_node(e_name)
