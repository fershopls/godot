extends Node

"""
add as singleton "Storage"

var STORAGE_LEVEL_ID = Storage.use('main.level_id', 'EMPTY')

await STORAGE_LEVEL_ID.read()
"""

signal storage_loaded

var data: Dictionary = {}
var file_path = "res://save.json"
var auto_save: bool

var _timer: Timer
var _is_loaded = false

func _ready():
	self._load()
	self._timer = _create_timer()
	
	_is_loaded = true
	storage_loaded.emit()

func _create_timer() -> Timer:
	var t = Timer.new()
	t.wait_time = 1.0
	t.one_shot = true
	add_child(t)
	t.connect('timeout', self._save)
	return t

func _save():
	var data = self.data.duplicate()
	for key in data:
		data[key] = var_to_str(data[key])
	
	var content = JSON.stringify(data, '  ')
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func _load():
	if not FileAccess.file_exists(file_path):
		return
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)
	
	if not data:
		return
	
	for key in data:
		data[key] = str_to_var(data[key])
	self.data = data

func _attempt_save_or_queue():
	if _timer.is_stopped():
		_timer.start()

func _write(key, value):
	data[key] = value
	
	if auto_save:
		_attempt_save_or_queue()

func _read(key, default):
	return data.get(key, default)

func _exists(key):
	return data.has(key)

func use(key, default):
	return StorageInstance.new(key, default)

class StorageInstance:
	var key
	var default
	func _init(key, default):
		self.key = key
		self.default = default
	
	func read(default = self.default):
		if not Storage._is_loaded:
			await Storage.storage_loaded
		
		return Storage._read(self.key, default)
	
	func write(value):
		Storage._write(self.key, value)
