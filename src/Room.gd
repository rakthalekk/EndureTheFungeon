class_name Room

extends TileMap

static var dimensions := Vector2i(16 * 16, 9 * 16)

var coords: Vector2i
var neighbors: Array[Room]

func _init(pos := Vector2i.ZERO):
	coords = pos
	pass

func _ready():
	# erase_cell(0, Vector2i(7, 0))
	# erase_cell(0, Vector2i(8, 0))

	pass

func SetNeighbors(friends: Array[Room]):
	neighbors = friends

	# print(neighbors)

	for friend in friends:
		var dir: Vector2 = (friend.coords - coords)
		dir = dir.normalized()
		
		# print(dir)

		if dir == Vector2.UP:
			print("top")
			set_cell(0, Vector2i(7, 0), 1, Vector2i(3, 2))
			set_cell(0, Vector2i(8, 0), 1, Vector2i(3, 2))
		elif dir == Vector2.RIGHT:
			print("right")
			set_cell(0, Vector2i(15, 4), 1, Vector2i(3, 2))
		elif dir == Vector2.DOWN:
			print("bot")
			set_cell(0, Vector2i(7, 8), 1, Vector2i(3, 2))
			set_cell(0, Vector2i(8, 8), 1, Vector2i(3, 2))
		elif dir == Vector2.LEFT:
			print("left")
			set_cell(0, Vector2i(0, 4), 1, Vector2i(3, 2))


	pass
