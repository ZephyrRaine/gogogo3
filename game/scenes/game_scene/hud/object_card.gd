extends Panel
class_name ObjectCard

@onready var stylebox: StyleBoxFlat = get_theme_stylebox("panel")
@export var hover_border_color = Color.WEB_GRAY
@export var selected_border_color = Color.WEB_GRAY

# Add these exports to your scene and link them to Labels in your Card scene [cite: 9]
@export var title_label : Label
@export var desc_label : Label
@export var price_label : Label

var clicked_signal : Signal
var item_id : String = "" # Store which item this card represents

var is_selected : bool:
	set(value):
		is_selected = value
		if is_selected:
			stylebox.border_color = selected_border_color
		else:
			stylebox.border_color = Color.TRANSPARENT

# Updated init to accept the item data dictionary [cite: 9]
func init(_clicked_signal, item_data: Dictionary):
	clicked_signal = _clicked_signal
	item_id = item_data["id"]

	if title_label:
		title_label.text = item_data["name"]
	if desc_label:
		desc_label.text = item_data["description"]

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		clicked_signal.emit(get_index()) # [cite: 9]
