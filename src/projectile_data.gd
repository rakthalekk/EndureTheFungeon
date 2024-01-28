class_name ProjectileData
extends Sprite2D

enum OnHit {BREAK, BOUNCE, SPLIT, EXPLODE, PIERCE}
enum MoveType {STANDARD, TRAP, ACCELERATE, DIRECTSINE, LATERALSINE}

@export var speed: float
@export var damage: int
@export var despawn_time: float
@export var acceleration: float
@export var bullet_radius: float
@export var align_to_heading: bool

@export var piercing_max: int
@export var max_bounces: int

@export var on_enemy_hit: OnHit
@export var on_wall_hit: OnHit
@export var on_timer_end: OnHit

@export var move_type: MoveType

@export var split_projectile: String
@export var num_split_projectiles: int
@export var split_angle: float

@export var explode_radius: float
@export var explosion_projectile: String
@export var trap_move_time: float

@export var sine_amplitude: float
@export var sine_frequency: float
