extends Node
class_name LaunchHud

@export var score_root:Control
@export var score_total_root:Control
@export var score_total_label: Label
@export var score_dist_label : Label
@export var score_bounce_label : Label

#display score values, send negative value as parameter to avoid modification
func display_score(total:int, bounce:int, dist:int):
	if total >= 0 :
		score_total_label.text = "%d" % [total]
	if bounce >= 0 :
		score_bounce_label.text = "%d" % [bounce]
	if dist >= 0 :
		score_dist_label.text = "%d" % [dist]

func set_score_visible(_visible:bool):
	score_root.visible = _visible

func set_total_score_visible(_visible:bool):
	score_total_root.visible = _visible
