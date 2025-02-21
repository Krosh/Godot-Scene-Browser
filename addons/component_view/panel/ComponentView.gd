@tool
extends Control
const ItemContainer = preload("./card/itemContainer.gd")

@onready var loaders = $"%Loaders"
var plugin

func set_plugin(item):
	loaders.plugin = plugin
	$"%AddToSceneButton".plugin = plugin
	plugin = item
	reload()

func reload():
	$"%AddToSceneButton".plugin = plugin
	var items_root = $"%ItemsRootContainer"
	for child in items_root.get_children():
		#Remove like this, so we can not free the child while things are happening on it.
		#(child as Node).tree_exited.connect(clear_child)
		items_root.remove_child(child)
		pass

	var collections = loaders.load_all(plugin) as Dictionary
	var category_list = $"%CategoryList"
	category_list.clear()

	for collection_name in collections.keys():
		create_collection(collection_name,collections[collection_name],category_list,items_root)
	pass

func clear_child(child):
	(child as Node).queue_free()

#Create a collection list.
func create_collection(collection_name:String,data:Array,category_list:ItemList,items_root:Control):
	category_list.add_item(collection_name)
	#Set up item container
	var container = ItemContainer.new()
	container.name = collection_name
	container.items = data
	container.plugin = plugin
	#Set up signals for searching.
	category_list.selection_finished.connect(container.was_selected)
	items_root.add_child(container)
	pass
