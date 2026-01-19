extends Node2D

class_name ForceIndicator

var enabled = true
@export var force_gauge_els : Array[Sprite2D]

@export var ui_el_distance = 8.0

func _ready() -> void:
	for s in force_gauge_els:
		s.visible = false

func set_target_speed(ratio):
	for i in range(len(force_gauge_els)):
		force_gauge_els[i].visible = ratio * len(force_gauge_els) >= i
