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
var can_be_selected = true
var card_data;

var is_selected : bool:
	set(value):
		is_selected = value
		if is_selected:
			stylebox.border_color = selected_border_color
		else:
			stylebox.border_color = Color.TRANSPARENT

# Updated init to accept the item data dictionary
func init(_clicked_signal, item_data: Dictionary):
	card_data = item_data
	clicked_signal = _clicked_signal
	item_id = item_data["id"]
	var raw_description = item_data.get("description", "")

	if item_data.has("effects") and item_data["effects"].size() > 0:
		var first_effect = item_data["effects"][0]

		var flat_value = str(first_effect["value"])
		# Optimization: If it's a multiplier (1.1), show it as a percentage (10)
		var percentage = (first_effect["value"] - 1.0) * 100
		# If value is < 1 (like 0.9 for gravity), show the reduction
		if first_effect["value"] < 1.0:
			percentage = (1.0 - first_effect["value"]) * 100
		var percentage_value = str(abs(round(percentage)))

		if (raw_description as String).contains("{value%}"):
			raw_description = raw_description.replace("{value%}", percentage_value)

		elif (raw_description as String).contains("{value}"):
			raw_description = raw_description.replace("{value}", flat_value)

		# 2. Parse the Chance (if it exists)
		if first_effect.has("chance"):
			var chance_val = str(round(first_effect["chance"] * 100))
			raw_description = raw_description.replace("{chance}", chance_val)

	if title_label:
		title_label.text = item_data.get("name", item_data["id"])
	if desc_label:
		desc_label.text = raw_description
	if price_label:
		price_label.text = "%d$" % item_data["price"]

func set_selectable(is_selectable):
	can_be_selected = is_selectable
	if !can_be_selected && is_selected:
		is_selected = false
	stylebox.bg_color = Color.WHITE if is_selectable else Color.DARK_GRAY

func _on_gui_input(event: InputEvent) -> void:
	if can_be_selected && event.is_action_pressed("interact"):
		clicked_signal.emit(get_index())
