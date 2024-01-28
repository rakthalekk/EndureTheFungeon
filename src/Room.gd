class_name Room

extends TileMap

static var dimensions := Vector2i(16 * 30 * 4, 9 * 30 * 4)
var enemyScene = preload("res://src/enemy.tscn")
var rng = RandomNumberGenerator.new()

enum Type {Enemy, Item, Shiny, Boss, Start}
var type: Type

var coords: Vector2i
var neighbors: Array[Room]
var cam
var visited := false

var enemies: Array[Enemy] = []

func _init(pos := Vector2i.ZERO):
	coords = pos
	# hi tommy XD (Hi Car-sama~!!)
	
	type = Type.Enemy if rng.randi_range(0, 1) == 1 else Type.Item
	pass

func _ready():
	pass

var elapsed = 0

func _process(delta):
	elapsed += delta
	
	if elapsed >= 2:
		Unlock()
	
	pass

func PlayerEntered(_body):
	get_parent().ChangeActiveRoom(self)

func SetNeighbors(friends: Array[Room]):
	neighbors = friends
	
	# Doors
	for friend in friends:
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()
		SetUnlockedCells(dir)

	pass

func Lock(_body, friendLock):
	if friendLock:
		get_parent().ChangeActiveRoom(self)
	
	if visited == true:
		return
	
	visited = true
	
	if (type == Type.Start):
		return
	
	# only lock if enemy room
	if (type == Type.Item):
		SpawnItems()
		return
	
	if type == Type.Shiny:
		SpawnShiny()
		return
	
	elapsed = 0
	
	for friend in neighbors:
		if friendLock:
			friend.Lock(null, false)
		
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()
		SetLockedCells(dir)
		
		if friendLock:
			SpawnEnemies()
	
	pass

func SpawnEnemies():
	var tiles = get_used_cells(0)
	var odds = 1
	var enemies = []
	var removedTiles = 0
	
	for tile in tiles:
		if get_cell_tile_data(0, tile).get_custom_data("EnemySpawn") == true:
			enemies.push_back(tile)
	
	while rng.randi_range(1, odds) == 1:
		var enemyData = EnemyDatabase.get_random_enemy_data()
		var enemy = enemyScene.instantiate()		
		call_deferred("add_child", enemy)
		
		var tile = enemies.pick_random()
		enemy.position = map_to_local(tile)
		enemies.remove_at(enemies.find(tile))
		removedTiles += 1
		
		if removedTiles > 2:
			odds += 1
	
	pass

func SpawnItems():
	var tiles = get_used_cells(0)
	var odds = 1
	var items = []
	var removedTiles = 0
	
	for tile in tiles:
		if get_cell_tile_data(0, tile).get_custom_data("ItemSpawn") == true:
			items.push_back(tile)
	
	while rng.randi_range(1, odds) == 1:
		var pickup: Pickup = PickupDatabase._get_minor_reward()
		var tile = items.pick_random()
		if tile == null:
			continue
		
		call_deferred("add_child", pickup)
		pickup.position = map_to_local(tile)
		items.remove_at(items.find(tile))
		removedTiles += 1
		
		if removedTiles > 2:
			odds += 1
			
	pass

func SpawnShiny():
	var tiles = get_used_cells(0)
	var items = []
	
	for tile in tiles:
		if get_cell_tile_data(0, tile).get_custom_data("RareItemSpawn") == true:
			items.push_back(tile)
			
	var pickup: Pickup = PickupDatabase._get_major_reward()
	var tile = items.pick_random()
	call_deferred("add_child", pickup)
	pickup.position = map_to_local(tile)
	items.remove_at(items.find(tile))
	
	pass

func Unlock():
	for friend in neighbors:
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()
		SetUnlockedCells(dir)

	pass
	
func SetUnlockedCells(dir: Vector2):
	if dir == Vector2.UP:
		set_cell(1, Vector2i(7, 0), 4, Vector2i(0, 0), 1)
		set_cell(1, Vector2i(8, 0), 4, Vector2i(0, 0))
		
		set_cell(2, Vector2i(7, 0), 11, Vector2i(0, 0), 1)
		set_cell(2, Vector2i(8, 0), 11, Vector2i(0, 0))
	elif dir == Vector2.RIGHT:
		set_cell(1, Vector2i(15, 3), 9, Vector2i(0, 0), 4)
		set_cell(1, Vector2i(15, 4), 7, Vector2i(0, 0), 2)
		set_cell(1, Vector2i(15, 5), 9, Vector2i(0, 0), 2)
		
		set_cell(2, Vector2i(15, 3), 12, Vector2i(0, 0), 4)
		set_cell(2, Vector2i(15, 4), 10, Vector2i(0, 0), 2)
		set_cell(2, Vector2i(15, 5), 12, Vector2i(0, 0), 2)
	elif dir == Vector2.DOWN:
		set_cell(1, Vector2i(7, 8), 4, Vector2i(0, 0), 2)
		set_cell(1, Vector2i(8, 8), 4, Vector2i(0, 0), 3)
		
		set_cell(2, Vector2i(7, 8), 11, Vector2i(0, 0), 2)
		set_cell(2, Vector2i(8, 8), 11, Vector2i(0, 0), 3)
	elif dir == Vector2.LEFT:
		set_cell(1, Vector2i(0, 3), 9, Vector2i(0, 0), 3)
		set_cell(1, Vector2i(0, 4), 7, Vector2i(0, 0), 1)
		set_cell(1, Vector2i(0, 5), 9, Vector2i(0, 0), 1)
		
		set_cell(2, Vector2i(0, 3), 12, Vector2i(0, 0), 3)
		set_cell(2, Vector2i(0, 4), 10, Vector2i(0, 0), 1)
		set_cell(2, Vector2i(0, 5), 12, Vector2i(0, 0), 1)
	
	pass
	
func SetLockedCells(dir: Vector2):
	if dir == Vector2.UP:
		set_cell(1, Vector2i(7, 0), 1, Vector2i(0, 0), 3)
		set_cell(1, Vector2i(8, 0), 1, Vector2i(0, 0), 3)
		
		erase_cell(2, Vector2i(7, 0))
		erase_cell(2, Vector2i(8, 0))
	elif dir == Vector2.RIGHT:
		set_cell(1, Vector2i(15, 3), 1, Vector2i(0, 0), 1)
		set_cell(1, Vector2i(15, 4), 1, Vector2i(0, 0), 1)
		set_cell(1, Vector2i(15, 5), 1, Vector2i(0, 0), 1)
		
		erase_cell(2, Vector2i(15, 3))
		erase_cell(2, Vector2i(15, 4))
		erase_cell(2, Vector2i(15, 5))
	elif dir == Vector2.DOWN:
		set_cell(1, Vector2i(7, 8), 1, Vector2i(0, 0), 3)
		set_cell(1, Vector2i(8, 8), 1, Vector2i(0, 0), 3)
		
		erase_cell(2, Vector2i(7, 8))
		erase_cell(2, Vector2i(8, 8))
	elif dir == Vector2.LEFT:
		set_cell(1, Vector2i(0, 3), 1, Vector2i(0, 0), 2)
		set_cell(1, Vector2i(0, 4), 1, Vector2i(0, 0), 2)
		set_cell(1, Vector2i(0, 5), 1, Vector2i(0, 0), 2)
		
		erase_cell(2, Vector2i(0, 3))
		erase_cell(2, Vector2i(0, 4))
		erase_cell(2, Vector2i(0, 5))
	
	pass
