class_name Room

extends TileMap

static var dimensions := Vector2i(16 * 30 * 4, 9 * 30 * 4)

var coords: Vector2i
var neighbors: Array[Room]
var cam

func _init(pos := Vector2i.ZERO):
	coords = pos
	pass

func _ready():
	pass

var elapsed = 0

func _process(delta):
	elapsed += delta
	
	if elapsed >= 2:
		UnLock()
	
	pass

func PlayerEntered(_body):
	get_parent().ChangeActiveRoom(self)

func SetNeighbors(friends: Array[Room]):
	neighbors = friends
	
	# Doors
	for friend in friends:
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()

		if dir == Vector2.UP:
			set_cell(0, Vector2i(7, 0), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(8, 0), 1, Vector2i(1, 0))
		elif dir == Vector2.RIGHT:
			set_cell(0, Vector2i(15, 3), 1, Vector2i(0, 0))
			set_cell(0, Vector2i(15, 4), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(15, 5), 1, Vector2i(0, 0), 1)
		elif dir == Vector2.DOWN:
			set_cell(0, Vector2i(7, 8), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(8, 8), 1, Vector2i(1, 0))
		elif dir == Vector2.LEFT:
			set_cell(0, Vector2i(0, 3), 1, Vector2i(0, 0))
			set_cell(0, Vector2i(0, 4), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(0, 5), 1, Vector2i(0, 0), 1)

	pass

func Lock(_body, friendLock):
	elapsed = 0
	
	for friend in neighbors:
		if friendLock:
			friend.Lock(null, false)
		
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()

		if dir == Vector2.UP:
			set_cell(0, Vector2i(7, 0), 1, Vector2i(1, 1))
			set_cell(0, Vector2i(8, 0), 1, Vector2i(1, 1))
		elif dir == Vector2.RIGHT:
			set_cell(0, Vector2i(15, 3), 1, Vector2i(1, 1))
			set_cell(0, Vector2i(15, 4), 1, Vector2i(1, 1))
			set_cell(0, Vector2i(15, 5), 1, Vector2i(1, 1))
		elif dir == Vector2.DOWN:
			set_cell(0, Vector2i(7, 8), 1, Vector2i(1, 1))
			set_cell(0, Vector2i(8, 8), 1, Vector2i(1, 1))
		elif dir == Vector2.LEFT:
			set_cell(0, Vector2i(0, 3), 1, Vector2i(1, 1))
			set_cell(0, Vector2i(0, 4), 1, Vector2i(1, 1))
			set_cell(0, Vector2i(0, 5), 1, Vector2i(1, 1))
	
	pass

func UnLock():
	for friend in neighbors:
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()

		if dir == Vector2.UP:
			set_cell(0, Vector2i(7, 0), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(8, 0), 1, Vector2i(1, 0))
		elif dir == Vector2.RIGHT:
			set_cell(0, Vector2i(15, 3), 1, Vector2i(0, 0))
			set_cell(0, Vector2i(15, 4), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(15, 5), 1, Vector2i(0, 0), 1)
		elif dir == Vector2.DOWN:
			set_cell(0, Vector2i(7, 8), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(8, 8), 1, Vector2i(1, 0))
		elif dir == Vector2.LEFT:
			set_cell(0, Vector2i(0, 3), 1, Vector2i(0, 0))
			set_cell(0, Vector2i(0, 4), 1, Vector2i(1, 0))
			set_cell(0, Vector2i(0, 5), 1, Vector2i(0, 0), 1)

	pass
