extends Node2D

var grid = []
@export var grid_width := 9
@export var grid_height := 9
@export var startCoords := Vector2i(5, 5)
@export var min_rooms := 10
@export var max_rooms := 20
@export var numItemRooms := 5
@export var numRareItemRooms := 2

var rng = RandomNumberGenerator.new()
var roomScene := preload("res://src/Room.tscn")
var playerScene := preload("res://src/player.tscn")

var cam
var currentRoom: Room
var roomAssignmentQueue: Array[Room] = []

func _ready():
	for i in grid_width:
		grid.append([])
		for j in grid_height:
			grid[i].append(null)
	
	GenerateMap()
	
	var player = playerScene.instantiate()
	add_child(player)
	cam = get_node("Camera2D")
	
	player.position = startCoords * Room.dimensions + (Room.dimensions / 2)
	#player.scale *= 0.2d
	cam.position = player.position

	pass

func _process(_delta):
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "position", Vector2(currentRoom.coords * Room.dimensions + (Room.dimensions / 2)), 0.4)
	
func GenerateMap():
	var numRooms = rng.randi_range(min_rooms, max_rooms) - 1
	var totalRooms = numRooms
	print(numRooms + 1)

	var roomQueue: Array[Room] = [CreateRoom(startCoords)]
	roomQueue.front().type = Room.Type.Start
	
	while (numRooms > 0):
		if roomQueue.size() <= 0:
			break

		if !HasEmptyNeighbors(roomQueue.front()):
			roomQueue.pop_front()
			continue

		var numNeighbors = NumNeighbors(roomQueue.front())

		if numNeighbors >= 4:
			roomQueue.pop_front()
			continue

		if numNeighbors >= 2 && rng.randi_range(0, 2) == 2:
			roomQueue.pop_front()
			continue

		var emptyNeighbors = GetEmptyNeighbors(roomQueue.front())
		var emptyNeighborsCount = emptyNeighbors.size()

		for n in emptyNeighborsCount:
			if numRooms <= 0:
				break
				
			if emptyNeighborsCount <= 2 && rng.randi_range(0, emptyNeighborsCount) == emptyNeighborsCount:
				break

			var room = CreateRoom(emptyNeighbors.pick_random())
			emptyNeighborsCount -= 1
				
			if room != null:
				roomQueue.push_front(room)
				roomAssignmentQueue.push_back(room)
				numRooms -= 1

	for i in grid_width:
		for j in grid_height:
			if grid[i][j] != null:
				grid[i][j].SetNeighbors(GetNeighbors(grid[i][j]))
				
	var remainingRareItems = numRareItemRooms
	var remainingItems = numItemRooms
	
	while !roomAssignmentQueue.is_empty():
		var currRoom: Room = roomAssignmentQueue.pick_random()
		roomAssignmentQueue.remove_at(roomAssignmentQueue.find(currRoom))
		
		if roomAssignmentQueue.size() == totalRooms - 1:
			var invalid = false
			for room in currRoom.neighbors:
				var dir: Vector2 = (room.coords - currRoom.coords)
				dir = dir.normalized()
				if dir == Vector2.UP:
					invalid = true
			
			if !invalid:
				continue
			
			currRoom.type = Room.Type.Boss
			continue
		
		if remainingRareItems > 0:
			currRoom.type = Room.Type.Shiny
			remainingRareItems -= 1
			continue
		
		if remainingItems > 0:
			currRoom.type = Room.Type.Item
			remainingItems -= 1
			continue
		
		currRoom.type = Room.Type.Enemy
				
	currentRoom = grid[startCoords.x][startCoords.y]
	
	pass

func ChangeActiveRoom(room: Room):
	currentRoom = room

func CreateRoom(pos: Vector2i):
	if InBounds(pos) && !GridContains(pos):
		var room = roomScene.instantiate()
		add_child(room)
		room.position = pos * Room.dimensions
		room.coords = pos
		grid[pos.x][pos.y] = room
		return grid[pos.x][pos.y]
	
	return null

func GridContains(pos: Vector2i):
	return grid[pos.x][pos.y] != null

func InBounds(pos: Vector2i):
	if (pos.x < 0 || pos.x >= grid_width):
		return false

	return !(pos.y < 0 || pos.y >= grid_width)

func NumNeighbors(room: Room):
	var pos = room.coords
	var numNeighbors = 0

	if GetRoom(pos + Vector2i.UP) != null:
		numNeighbors += 1
	
	if GetRoom(pos + Vector2i.RIGHT) != null:
		numNeighbors += 1

	if GetRoom(pos + Vector2i.DOWN) != null:
		numNeighbors += 1
	
	if GetRoom(pos + Vector2i.LEFT) != null:
		numNeighbors += 1
	
	return numNeighbors

func GetRoom(pos: Vector2i):
	if InBounds(pos):
		return grid[pos.x][pos.y]
	
	return null

func HasEmptyNeighbors(room: Room):
	return GetEmptyNeighbors(room).size() > 0

func GetEmptyNeighbors(room: Room):
	var neighbors: Array[Vector2i] = []
	var coords = room.coords
	
	if InBounds(coords + Vector2i.UP) && GetRoom(coords + Vector2i.UP) == null:
		neighbors.push_back(coords + Vector2i.UP)
	
	if InBounds(coords + Vector2i.RIGHT) && GetRoom(coords + Vector2i.RIGHT) == null:
		neighbors.push_back(coords + Vector2i.RIGHT)

	if InBounds(coords + Vector2i.DOWN) && GetRoom(coords + Vector2i.DOWN) == null:
		neighbors.push_back(coords + Vector2i.DOWN)

	if InBounds(coords + Vector2i.LEFT) && GetRoom(coords + Vector2i.LEFT) == null:
		neighbors.push_back(coords + Vector2i.LEFT)
	
	return neighbors

func GetNeighbors(room: Room):
	var neighbors: Array[Room] = []
	var coords = room.coords

	if GetRoom(coords + Vector2i.UP) != null:
		neighbors.push_back(GetRoom(coords + Vector2i.UP))
	
	if GetRoom(coords + Vector2i.RIGHT) != null:
		neighbors.push_back(GetRoom(coords + Vector2i.RIGHT))

	if GetRoom(coords + Vector2i.DOWN) != null:
		neighbors.push_back(GetRoom(coords + Vector2i.DOWN))

	if GetRoom(coords + Vector2i.LEFT) != null:
		neighbors.push_back(GetRoom(coords + Vector2i.LEFT))

	return neighbors
