@tool
extends Control
@export var plugin:EditorPlugin
@export var component_name = "Empty"
@export var scene:PackedScene

var texture = null
var _selected = false

func _ready():
	tooltip_text = component_name
	if scene == null:
		return
	if texture != null:
		$TextureRect.texture = texture
	pass


func _on_ComponentCard_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			if event.double_click:
				var selected = plugin.get_editor_interface().get_selection().get_selected_nodes()
				if selected.is_empty():
					return
				var owner_node = plugin.get_editor_interface().get_edited_scene_root()
				_selected = true
				add_to_scene(selected[0],owner_node)
			else:
				selected(null)
	pass

func selected(zelf):
	if zelf == null:
		_selected = !_selected
		get_tree().call_group("element_editor_card","selected",self)
		get_tree().call_group("element_item_display","update_selection",self)
	elif zelf != self:
		_selected = false
	$ColorRect.visible = _selected
	pass

func searched_for(text:String):
	if text.is_empty():
		visible = true
	else:
		visible = component_name.to_lower().find(text) >-1

func add_to_scene(selected_node:Node,owner_node:Node):
	if _selected:
		var new_node = scene.instantiate()
		new_node.name = component_name
		new_node.tree_entered.connect(func(): new_node.owner = owner_node,CONNECT_ONE_SHOT)
		selected_node.add_child(new_node)
	pass
