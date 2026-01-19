class_name EffectsManager
extends Control

@export var rebound_label_lucky:ReboundLabel
@export var rebound_label_eagle:ReboundLabel
@export var rebound_label_holy:ReboundLabel
@export var rebound_label_dash:ReboundLabel
var pebble:Pebble

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.bounce.connect(on_bounce)

func on_bounce(is_lucky:bool):
	if is_lucky:
		rebound_label_lucky.start_anim(pebble.get_global_transform_with_canvas().origin)
		
	if pebble.current_bounce_is_eagle:
		rebound_label_eagle.start_anim(pebble.get_global_transform_with_canvas().origin)
		
	if pebble.current_bounce_is_holy:
		rebound_label_holy.start_anim(pebble.get_global_transform_with_canvas().origin)
		
	if pebble.current_bounce_is_dash:
		rebound_label_dash.start_anim(pebble.get_global_transform_with_canvas().origin)
