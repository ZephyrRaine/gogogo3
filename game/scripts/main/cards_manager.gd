extends HBoxContainer
class_name CardsManager

signal selected_card(index)

@export var card_prefab: PackedScene
var currently_selected: int = -1
var displayed_item_ids: Array[String] = [] # Track what items are currently in the shop [cite: 8]

func _ready() -> void:
	selected_card.connect(card_clicked) # [cite: 8]
	EventBus.shop_requested.connect(shop_requested) # [cite: 8]

func shop_requested():
	for n in get_children():
		n.queue_free() # [cite: 8]

	currently_selected = -1
	displayed_item_ids.clear()

	# Get all possible IDs from our ObjectManager DB
	var available_ids = ObjectManager.all_items_db.keys()
	available_ids.shuffle() # Randomize the order

	for i in range(min(3, available_ids.size())):
		var item_id = available_ids[i]
		var item_data = ObjectManager.all_items_db[item_id]

		var card = card_prefab.instantiate() as ObjectCard
		add_child(card)
		card.init(selected_card, item_data) # Pass the item data to the card [cite: 8, 9]
		displayed_item_ids.append(item_id)

func card_clicked(index: int):
	if currently_selected != -1:
		(get_child(currently_selected) as ObjectCard).is_selected = false # [cite: 8]
	currently_selected = index
	(get_child(currently_selected) as ObjectCard).is_selected = true # [cite: 8]

func continue_clicked():
	# If a card was selected, equip it before closing the shop [cite: 8, 10]
	if currently_selected != -1:
		var chosen_id = displayed_item_ids[currently_selected]
		ObjectManager.equip_item(chosen_id)
		print("Equipped: ", chosen_id)

	EventBus.shop_ended.emit() # [cite: 8]
