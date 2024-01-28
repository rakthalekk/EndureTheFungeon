class_name EnemyData
extends Sprite2D

enum MoveType {APPROACH, FLEE, STRAFE, CRAWL, IDLE}
enum ShootType {DIRECT, SPIRAL, SPREAD, NONE}

@export var speed = 100
@export var nearby_distance = 300

@export var max_haha_points: int
@export var i_frames: float

@export var move_pattern: MoveType
@export var shoot_pattern: ShootType
