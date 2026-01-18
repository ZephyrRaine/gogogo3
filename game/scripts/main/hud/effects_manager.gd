class_name EffectsManager
extends Control

@export var rebound_label_lucky:ReboundLabel
var pebble:Pebble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.bounce.connect(on_bounce)

func on_bounce(is_lucky:bool):
	if (is_lucky):
		rebound_label_lucky.start_anim(pebble.get_global_transform_with_canvas().origin)
