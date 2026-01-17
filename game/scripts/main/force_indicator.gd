extends Node2D

class_name ForceIndicator

@export var force_gauge_el_texture: Texture2D
@export var max_force_elements = 8
var enabled = true
var force_gauge_els : Array[Sprite2D]

@export var ui_el_distance = 8.0

func _ready() -> void:
	for i in range(max_force_elements):
		var newEl = Sprite2D.new()
		add_child(newEl)
		newEl.texture = force_gauge_el_texture
		newEl.position.x += i*ui_el_distance
		newEl.scale.y *= 1+ i* 0.1
		newEl.visible = false
		force_gauge_els.append(newEl)

func set_target_speed(ratio):
	for i in range(max_force_elements):
		force_gauge_els[i].visible = ratio * max_force_elements >= i
