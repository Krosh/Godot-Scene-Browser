@tool
extends Node

@export var root_path = "res://assets/components/"
var plugin


func _find_mesh(node: Node):
	if not node:
		return null
	var mesh = node.get("mesh")
	if mesh:
		return node.mesh
	elif node.has_method("get_mesh"):
		return node.get_mesh()
	for item in node.get_children():
		mesh = _find_mesh(item)
		if mesh:
			return mesh


func load_all(plugin:EditorPlugin):
	var datas = []
	var collections = {}
	var icon_map = {}

	print("plugin", plugin)
	if plugin != null:
		for child in get_children():
			var data = child.load_collections(root_path)
			#Merge the dictionaries properly.
			for key in data.keys():
				if not collections.has(key):
					collections[key] = []
				var data_array = data[key]
				#Map the individual items to their meshes.
				for item in data_array:
					if item.scene is PackedScene:
						var root = item.scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED) as Node
						var mesh = _find_mesh(root)
						if mesh != null:
							icon_map[item] = mesh
						root.queue_free()

				(collections[key] as Array).append_array(data_array)
			pass

	print(icon_map.size())

	var missing_icon_map = {}

	for item in icon_map.keys():
		var icon = load_preview_if_cached(item)
		#print(icon)
		if icon:
			item["icon"] = icon
		else:
			missing_icon_map[item] = icon_map[item]

	var icons = plugin.get_editor_interface().make_mesh_previews(missing_icon_map.values(),256)
	#Place all the icons into the correct items.
	for i in missing_icon_map.keys().size():
		var item = missing_icon_map.keys()[i]
		item["icon"] = icons[i]
		save_preview_to_cache(item)

	return collections

func make_root(item):
	return "res://.scene_previews/"+item.collection+"/"

func make_preview_key(item):
	return make_root(item)+item.name+".png"

func load_preview_if_cached(item)->Texture:
	var key = make_preview_key(item)
	var image = Image.load_from_file(key)
	var texture = ImageTexture.create_from_image(image)
	return texture


func save_preview_to_cache(item):
	DirAccess.open("res://").make_dir_recursive(".scene_previews/" + item.collection)
	var export_path = make_preview_key(item)
	var export_img = item.icon.get_image()
	export_img.convert(Image.FORMAT_RGBA8)
	export_img.save_png(export_path)
