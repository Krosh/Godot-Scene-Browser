@tool
extends ItemList

signal selection_finished(array)

func _ready():
#	nothing_selected.connect(selected)
	item_selected.connect(item_selected_callback)
	multi_selected.connect(multi_selected_callback)
	pass

func selected():
	var selected = []
	for index in get_selected_items():
		selected.append(get_item_text(index))
		pass
	selection_finished.emit(selected)
	pass

func item_selected_callback(index):
	selected()
	pass

func multi_selected_callback(index,selected):
	selected()
	pass
