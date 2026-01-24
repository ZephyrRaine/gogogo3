extends Node

# Stores loaded item definitions
var all_items_db: Dictionary = {}

var available_items_db: Dictionary = {}

# Stores currently equipped/active items (Array of item dictionaries)
var active_items: Array = []
# Stores permanent buffs (like Sniper Training speed)
var permanent_stats: Dictionary = {
	"initial_speed_perm_buff": 0.0,
	"final_score_multiplier": 1.0
}

func _ready():
	load_database("res://objects.json") # Make sure to put your json in res://

func load_database(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			var data = json.data
			for item in data:
				all_items_db[item["id"]] = item
				available_items_db[item["id"]] = item
		else:
			print("JSON Error: ", json.get_error_message())

# Call this to equip an item by ID
func equip_item(item_id: String):
	if item_id in all_items_db and item_id in available_items_db:
		# Duplicate so we can modify 'uses_remaining' independently
		active_items.append(all_items_db[item_id].duplicate(true))
		available_items_db.erase(item_id);

func sell_item(item_id: String):
	if item_id in all_items_db and item_id in available_items_db:
		available_items_db[item_id] = (all_items_db[item_id].duplicate(true))

# --- THE PARSER ---

# Generic function to apply effects to a target object or dictionary
func apply_trigger(trigger_name: String, target: Variant) -> void:

	# 1. Apply Permanent Stats first (if applicable)
	if trigger_name == "on_launch" and target.get("initial_speed") != null:
		target.initial_speed *= (1.0 + permanent_stats["initial_speed_perm_buff"])

	# 2. Iterate through equipped items
	for i in range(active_items.size() - 1, -1, -1):
		var item = active_items[i]

		# Handle "Uses Remaining" logic
		if item.has("uses_remaining"):
			if item["uses_remaining"] <= 0:
				continue

		for effect in item["effects"]:
			if effect["trigger"] != trigger_name:
				continue

			# Handle Chance (RNG)
			if effect.has("chance"):
				if randf() > effect["chance"]:
					continue

			EventBus.activate_object_feedback.emit(item["id"])
			# Handle Permanent vs Temporary logic
			if effect.get("is_permanent", false):
				_modify_stat(permanent_stats, effect["stat"], effect["op"], effect["value"])
			else:
				# Apply to the target (Pebble, Score Dict, etc)
				_modify_stat(target, effect["stat"], effect["op"], effect["value"])

		# Decrement usage logic
		if trigger_name == "on_launch" and item.has("uses_remaining"):
			item["uses_remaining"] -= 1
			if item["uses_remaining"] <= 0:
				print(item["name"] + " expired!")
				# Optional: active_items.remove_at(i)

# Math Helper
func _modify_stat(target, stat_name: String, op: String, value: float):
	# If target is a Dictionary (like context data)
	if target is Dictionary:
		if target.has(stat_name):
			target[stat_name] = _calculate(target[stat_name], op, value)
	# If target is an Object (like Pebble)
	elif target is Object:
		var current = target.get(stat_name)
		if current != null:
			target.set(stat_name, _calculate(current, op, value))

func _calculate(a, op, b):
	match op:
		"add": return a + b
		"mul": return a * b
		"set": return b
	return a
