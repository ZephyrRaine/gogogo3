extends Control
class_name HudObject

var data : Dictionary

func _ready() -> void:
	EventBus.activate_object_feedback.connect(feedback)

func feedback(item_id:String):
	if(item_id == data["id"]):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "scale", Vector2(0.5, 0.5), .5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), .5).set_trans(Tween.TRANS_SINE)
