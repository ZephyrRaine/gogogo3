extends MarginContainer

@export var row_label:Label
@export var player:Control
@export var playerAnim:ColorRect

func set_row(index, goal, gain, is_player):
	row_label.text = "#%d " % index
	if is_player:
		player.visible = true
		row_label.text += " (you) "
		
	else:
		player.visible = false

	row_label.text += "| %d | " % goal
	if(gain == -1):
		row_label.text += "GAME OVER"
	else:
		row_label.text += "+%d$" % gain

func squeeze_anim():
	var tween = get_tree().create_tween()
	var colorA = playerAnim.color
	var colorB = playerAnim.color
	colorB.a = 1.0
	for i in range(0, 2):
		tween.tween_property($PanelContainer/Margin_playerAnim/ColorRect,"color", colorB, 0.2)
		tween.tween_property($PanelContainer/Margin_playerAnim/ColorRect,"color", colorA, 0.1)
