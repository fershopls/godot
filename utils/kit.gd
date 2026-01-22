extends CanvasLayer
"""
singleton: Debug

Debug.track({ "velocity": value })
"""

var font_size = 11

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if not OS.has_feature("editor"):
		queue_free()

func _input(event):
	if not (event as InputEventKey):
		return
	
	if not event.pressed or event.is_echo():
		return
	
	if not Input.is_key_label_pressed(KEY_SHIFT):
		return
	
	shortcuts()

func shortcuts():
	if Input.is_key_label_pressed(KEY_R):
		restart()
	
	if Input.is_key_label_pressed(KEY_4):
		screenshot()
	
	if Input.is_key_label_pressed(KEY_P):
		get_tree().paused = not get_tree().paused
	
	if Input.is_key_label_pressed(KEY_F):
		var window = get_window()
		if window.mode != Window.MODE_MAXIMIZED:
			window.mode = Window.MODE_MAXIMIZED
		else:
			window.mode = Window.MODE_WINDOWED

func restart():
	Engine.time_scale = 1
	get_tree().paused = false
	get_tree().reload_current_scene()

func screenshot():
	var image = get_viewport().get_texture().get_image()
	var path = 'res://SCREENSHOT_'
	var dir = DirAccess.open('res://')
	if dir.dir_exists('assets'):
		path = 'res://assets/SCREENSHOT_'
	
	image.save_png(path + str(timestamp()) + '.png')

var track_data: = {}
var track_label
func track(values):
	if not track_label:
		track_label = _create_track_label()
	
	if typeof(values) != TYPE_DICTIONARY:
		values = {'value': values}
	
	track_data.merge(values, true)

func _create_track_label():
	var m = instantiate(MarginContainer.new(), self)
	var p: Panel = instantiate(Panel.new(), m)
	var bg = StyleBoxFlat.new()
	bg.bg_color = Color.BLACK
	p.add_theme_stylebox_override('panel', bg)
	var l: Label = instantiate(Label.new(), m)
	l.add_theme_font_size_override('font_size', font_size)
	return l

func _track_get_value(value) -> String:
	# Vector2
	if typeof(value) == TYPE_VECTOR2:
		value = value.floor()
		return str(value.x)+', '+str(value.y)
	
	if typeof(value) == TYPE_VECTOR2I:
		return str(value.x)+', '+str(value.y)
	
	# String
	if typeof(value) == TYPE_STRING:
		return value
	
	return var_to_str(value)

func _process(delta):
	if track_label:
		var text = ""
		for key in track_data:
			text += key+": "+_track_get_value(track_data[key])+"\n"
		track_label.text = text

static func instantiate(node, parent: Node, at = null):
	if typeof(node) == TYPE_STRING:
		node = load(node).instantiate()
	elif node is PackedScene:
		node = node.instantiate()
	
	parent.add_child(node)
	
	if at:
		node.global_position = at
	
	return node

static func timestamp():
	return int(Time.get_unix_time_from_system())
