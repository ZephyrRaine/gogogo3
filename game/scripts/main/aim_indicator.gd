extends Node2D

class_name AimIndicator

@export var needle_pivot: Node2D
@export var target_pivot: Node2D
@export var rotation_limit = 25.6
var enabled = true


func set_target_rotation(ratio):
	target_pivot.rotation_degrees = lerp(-rotation_limit, rotation_limit, ratio)


func set_needle_rotation(ratio):
	needle_pivot.rotation_degrees = lerp(-rotation_limit, rotation_limit, ratio)
