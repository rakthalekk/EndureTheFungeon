class_name ProjectileData
extends Sprite2D

enum OnHit {BREAK, BOUNCE, SPLIT, EXPLODE, PIERCE}
enum MoveType {STANDARD, TRAP, ACCELERATE}

@export var speed: float
@export var damage: int
@export var despawn_time: float
@export var acceleration: float
@export var bullet_radius: float

@export var piercing_max: int
@export var max_bounces: int

@export var on_enemy_hit: OnHit
@export var on_wall_hit: OnHit
@export var on_timer_end: OnHit

@export var move_type: MoveType

@export var split_projectile: ProjectileData
@export var num_split_projectiles: int
@export var explode_radius: float