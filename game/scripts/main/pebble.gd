extends Node2D
class_name Pebble

@export var initial_position: Vector2
@export var initial_speed = 1.0
@export var gravity = 9.81
@export var bounce_ratio = 0.8
@export var friction_y = 0.98
@export var friction_x = 0.98
@export var water_height = 93.0
@export var min_bounce_velocity = 10

var direction: Vector2
var speed: float
var velocity: Vector2

var distance
var bounces


func _ready() -> void:
	visible = false
	EventBus.scoring_done.connect(func(): position = initial_position)


func launch_pebble(_direction: Vector2, force: float):
	visible = true
	position = initial_position
	direction = _direction
	speed = initial_speed * force
	velocity = direction * speed

	distance = 0
	bounces = 0


func _process(delta: float) -> void:
	if !visible:
		return

	velocity.y += gravity * delta
	#velocity.y *= friction_y
	#velocity.x *= friction_x
	position += velocity * delta
	distance = position.x - initial_position.x
	if position.y > water_height:
		if velocity.y > min_bounce_velocity:
			bounces += 1
			velocity.y *= -bounce_ratio
			position.y = 92.9
		else:
			visible = false
			EventBus.launch_done.emit(distance, bounces)
