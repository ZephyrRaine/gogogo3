extends HBoxContainer

class_name CardsManager

signal selected_card(index)

@export var card_prefab: PackedScene
var currently_selected: int = -1


func _ready() -> void:
	selected_card.connect(card_clicked)
	EventBus.shop_requested.connect(shop_requested)


func shop_requested():
	for n in get_children():
		n.queue_free()

	currently_selected = -1
	for i in range(3):
		var card = card_prefab.instantiate()
		card.init(selected_card)
		add_child(card)


func card_clicked(index: int):
	if currently_selected != -1:
		(get_child(currently_selected) as ObjectCard).is_selected = false
	currently_selected = index
	(get_child(currently_selected) as ObjectCard).is_selected = true


func continue_clicked():
	EventBus.shop_ended.emit()
