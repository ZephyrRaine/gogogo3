extends MarginContainer

@export var row_label:Label
@export var color_rect:ColorRect

func set_row(index, goal, gain, is_player):
	row_label.text = "#%d " % index
	if is_player:
		color_rect.color = Color("396d39")
		row_label.text += " (you) "
	else:
		color_rect.color = Color("474145")

	row_label.text += "| %d | " % goal
	if(gain == -1):
		row_label.text += "GAME OVER"
	else:
		row_label.text += "+%d$" % gain
