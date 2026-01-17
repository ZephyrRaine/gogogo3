extends CanvasLayer
class_name HUD

@export var score_label : Label
@export var shop : Control

func _ready() -> void:
	EventBus.shop_requested.connect(display_shop)
	EventBus.shop_ended.connect(hide_shop)
	EventBus.scoring_show.connect(display_score)

func _input(event: InputEvent) -> void:
	if !score_label.visible || !event.is_action_pressed("interact"):
		return


	EventBus.scoring_done.emit()
	score_label.visible = false

func display_score(distance: float, bounces: int, target_score: int):
	score_label.visible = true
	score_label.text = "target : %d" % [target_score]
	score_label.text += "\n%d x %d = %d" % [distance, bounces + 1, distance * (bounces + 1)]

func display_shop():
	shop.visible = true

func hide_shop():
	shop.visible = false
