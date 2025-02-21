@tool
extends HFlowContainer
const Card = preload("./ComponentCard.tscn")

var plugin:EditorPlugin
@export var items = []

func _ready():
	size_flags_horizontal = SIZE_EXPAND_FILL
	for item in items:
		var card = Card.instantiate()
		card.component_name = item.name
		card.name = item.name
		card.texture = item.get("icon",null)
		card.plugin = plugin
		card.scene = item.scene

		call_deferred("add_child", card)
		pass
	pass

func was_selected(items):
	if items.is_empty():
		visible = true
	else:
		visible = items.has(name)
	pass
