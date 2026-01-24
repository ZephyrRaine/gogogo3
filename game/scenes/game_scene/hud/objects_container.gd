extends VBoxContainer
class_name ObjectsContainer

@export var object_prefab: PackedScene

func _ready():
	EventBus.buy_object.connect(object_bought)

func object_bought(item_data : Dictionary):
	for c in get_children():
		if c.get_child_count() == 0:
			var instance = object_prefab.instantiate() as HudObject
			instance.data = item_data
			c.add_child(instance)
			return
	print("SHOULDN'T REACH THIS")
