@tool
extends EditorPlugin

const ComponentView = preload("res://addons/component_view/panel/ComponentView.tscn")
var view
@export var component_path = "assets/components/"

func _enter_tree():
	view = ComponentView.instantiate()
	add_control_to_bottom_panel(view,"Scene Browser")
	view.set_plugin(self)

	var dir = DirAccess.open("res://")
	if(not dir.dir_exists(component_path)):
		dir.make_dir(component_path)

	pass


func _exit_tree():
	remove_control_from_bottom_panel(view)
	view.queue_free()
	pass
