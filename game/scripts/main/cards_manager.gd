extends HBoxContainer
class_name CardsManager

signal selected_card(index)

@export var reroll_cost: int = 0
@export var card_prefab: PackedScene
@export var money_label: Label
var currently_selected: int = -1
var displayed_item_ids: Array[String] = []
var temp_money = 0:
	set(v):
		temp_money = v
		money_label.text = "%d$" % temp_money


func _ready() -> void:
	selected_card.connect(card_clicked)
	EventBus.shop_requested.connect(shop_requested)
	EventBus.spend_money.connect(spend_money)


func spend_money(_previous_money: int, new_money: int):
	temp_money = new_money


func shop_requested(money: int):
	temp_money = money
	for n in get_children():
		n.queue_free()

	currently_selected = -1
	displayed_item_ids.clear()

	# Get all possible IDs from our ObjectManager DB
	var available_ids = ObjectManager.all_items_db.keys()
	available_ids.shuffle()

	for i in range(min(3, available_ids.size())):
		var item_id = available_ids[i]
		var item_data = ObjectManager.all_items_db[item_id]

		var card = card_prefab.instantiate() as ObjectCard
		add_child(card)
		card.init(selected_card, item_data)
		displayed_item_ids.append(item_id)


func card_clicked(index: int):
	if currently_selected != -1:
		(get_child(currently_selected) as ObjectCard).is_selected = false
	currently_selected = index
	(get_child(currently_selected) as ObjectCard).is_selected = true


func buy_clicked():
	if currently_selected != -1:
		var target_card = get_child(currently_selected) as ObjectCard
		if temp_money >= target_card.card_data["price"]:
			var chosen_id = displayed_item_ids[currently_selected]
			ObjectManager.equip_item(chosen_id)
			target_card.set_selectable(false)
			currently_selected = -1
			EventBus.spend_money.emit(temp_money, temp_money - target_card.card_data["price"])


func close_clicked():
	EventBus.shop_ended.emit()


func _on_reroll_pressed() -> void:
	if(temp_money - reroll_cost >= 0):
		shop_requested(temp_money - reroll_cost)
