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

func Lock(_body, friendLock):
	elapsed = 0
	
	for friend in neighbors:
		if friendLock:
			friend.Lock(null, false)
		
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()

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

func UnLock():
	for friend in neighbors:
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()

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
