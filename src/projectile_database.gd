extends Node2D


func _ready():
	hide()


func get_projectile_data(p_name: String) -> ProjectileData:
	return get_node(p_name)
