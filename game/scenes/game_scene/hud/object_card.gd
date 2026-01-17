extends Panel
class_name ObjectCard

@onready var stylebox: StyleBoxFlat = get_theme_stylebox("panel")

@export var hover_border_color = Color.WEB_GRAY
@export var selected_border_color = Color.WEB_GRAY

var clicked_signal : Signal

var is_selected : bool:
	set(value):
		is_selected = value
		if is_selected:
			stylebox.border_color = selected_border_color
		else:
			stylebox.border_color = Color.TRANSPARENT

func init(_clicked_signal):
	clicked_signal = _clicked_signal

func _on_mouse_entered():
	if !is_selected:
		stylebox.border_color = hover_border_color


func _on_mouse_exited():
	if !is_selected:
		stylebox.border_color = Color.TRANSPARENT

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		clicked_signal.emit(get_index())
