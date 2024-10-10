extends CanvasLayer
"""
singleton: Debug
"""
func _ready():
	print('nigga')
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
	
	image.save_png(path + str(Kit.timestamp()) + '.png')

var track_data: = {}
var track_label
func track(data):
	if not track_label:
		var m = Kit.instantiate(MarginContainer.new(), self)
		var p: Panel = Kit.instantiate(Panel.new(), m)
		var bg = StyleBoxFlat.new()
		bg.bg_color = Color.BLACK
		p.add_theme_stylebox_override('panel', bg)
		track_label = Kit.instantiate(Label.new(), m)
	
	if typeof(data) != TYPE_DICTIONARY:
		data = {"value": data}
	
	for key in data:
		if data[key] is Vector2:
			data[key] = data[key].floor()
	
	track_data.merge(data, true)

func _process(delta):
	if track_label:
		var text = ""
		for key in track_data:
			text = key+": "+var_to_str(track_data[key])+"\n"
		track_label.text = text
