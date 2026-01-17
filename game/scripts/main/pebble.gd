extends Node2D
class_name Pebble


func _ready() -> void:
	visible = false


@export var initial_position: Vector2
@export var initial_speed = 1.0
@export var gravity = 9.81
@export var friction_y = 0.98
@export var friction_x = 0.98

var direction: Vector2
var speed: float
var velocity: Vector2

var distance
var bounces

#TODO: clean cette merde
@onready var label = $Camera2D/CanvasLayer/Label


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
	label.text = "%d x %d = %.3f" % [distance, bounces + 1, distance * bounces]
	if position.y > 93.0:
		print(velocity.y)
		if velocity.y > 10:
			bounces += 1
			velocity.y *= -0.8
			position.y = 92.9
		else:
			visible = false
