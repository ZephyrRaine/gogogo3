extends CanvasLayer
class_name HUD

@export var score_label: Label
@export var shop: Control


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
	# Create a context object to calculate the final numbers
	var score_ctx = {"score_distance": distance, "final_score": 0}

	# Apply modifiers (like "Headstart")
	ObjectManager.apply_trigger("on_score", score_ctx)

	var final_dist = score_ctx["score_distance"]

	# Apply the Permanent Multiplier (Bullseye Bonus)
	var multiplier = (bounces + 1) * ObjectManager.permanent_stats["final_score_multiplier"]

	score_label.visible = true
	score_label.text = "target : %d" % [target_score]
	# Update text logic to use modified values
	score_label.text += "\n%d x %.1f = %d" % [final_dist, multiplier, final_dist * multiplier]


func display_shop():
	shop.visible = true


func hide_shop():
	shop.visible = false
