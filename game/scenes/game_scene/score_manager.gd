extends CanvasLayer

@onready var score_label = $"ScoreLabel"


func _ready() -> void:
	EventBus.launch_done.connect(display_score)

func _input(event: InputEvent) -> void:
	if !score_label.visible || !event.is_action_pressed("interact"):
		return


	EventBus.scoring_done.emit()
	score_label.visible = false

func display_score(distance: float, bounces: int):
	score_label.visible = true
	score_label.text = "%d x %d = %d" % [distance, bounces + 1, distance * (bounces + 1)]
