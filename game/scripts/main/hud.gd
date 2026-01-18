extends CanvasLayer
class_name HUD

@export var score_label: Label
@export var shop: Control
@export var tournament_view : TournamentView

var round_score
var round_rank

func _ready() -> void:
	EventBus.shop_requested.connect(display_shop)
	EventBus.shop_ended.connect(hide_shop)
	EventBus.scoring_show.connect(display_score)
	EventBus.show_tournament.connect(show_tournament_requested)


func _input(event: InputEvent) -> void:
	if score_label.visible && event.is_action_pressed("interact"):
		score_label.visible = false
		await get_tree().create_timer(0.25).timeout
		EventBus.scoring_done.emit(round_score)

	elif tournament_view.visible && event.is_action_pressed("interact"):
		tournament_view.visible = false
		print("CLOSED")
		await get_tree().create_timer(0.25).timeout
		EventBus.hide_tournament.emit(round_rank)


func display_score(distance: float, bounces: int):
	# Create a context object to calculate the final numbers
	var score_ctx = {"score_distance": distance, "final_score": 0}

	# Apply modifiers (like "Headstart")
	ObjectManager.apply_trigger("on_score", score_ctx)

	var final_dist = score_ctx["score_distance"]

	# Apply the Permanent Multiplier (Bullseye Bonus)
	var multiplier = (bounces + 1) * ObjectManager.permanent_stats["final_score_multiplier"]

	score_label.visible = true
	# Update text logic to use modified values
	round_score = final_dist * multiplier
	score_label.text = "\n%d x %.1f = %d" % [final_dist, multiplier, round_score]


func display_shop():
	shop.visible = true


func hide_shop():
	shop.visible = false

func show_tournament_requested(day_index, round_index, player_score):
	round_rank = tournament_view.display_tournament([8500, 7500, 6500, 5500, 4500, 3500, 2500], player_score, day_index, round_index)
