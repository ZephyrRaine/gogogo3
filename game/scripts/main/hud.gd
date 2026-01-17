extends CanvasLayer
class_name HUD

@export var score_label : Label
@export var shop : Control

func _ready() -> void:
	EventBus.launch_done.connect(display_score)
	EventBus.shop_requested.connect(display_shop)
	EventBus.shop_ended.connect(hide_shop)

func _input(event: InputEvent) -> void:
	if !score_label.visible || !event.is_action_pressed("interact"):
		return


	EventBus.scoring_done.emit()
	score_label.visible = false

func display_score(distance: float, bounces: int):
	score_label.visible = true
	score_label.text = "%d x %d = %d" % [distance, bounces + 1, distance * (bounces + 1)]

func display_shop():
	shop.visible = true

func hide_shop():
	shop.visible = false
