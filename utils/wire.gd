extends Node

signal wire_written(global_key, value)

var wires = {}

func use(node, wire_key):
	return WireInstance.new(node, wire_key)

func write(key, value):
	# resolve value
	if typeof(value) == TYPE_CALLABLE:
		value = value.call(wires.get(key))
	
	wires[key] = value
	wire_written.emit(key, value)

func read(key):
	return wires.get(key)

func clear_wires():
	wires = {}

class WireInstance:
	var node: Node
	var local_key
	var global_key
	var listeners = []
	func _init(node, local_key):
		self.node = node
		self.local_key = local_key
		self.global_key = get_wire_global_key()
		
		Wire.connect('wire_written', self.wire_written)
	
	func get_wire_global_key():
		for node in node.get_children():
			var namespaces = node.name.split('_')
			
			if namespaces[0] != 'WIRE':
				continue
			
			var node_wire_local_key = namespaces[1]
			var node_wire_global_key = namespaces[2]
			
			if node_wire_local_key == self.local_key:
				return node_wire_global_key
		return null
	
	func read(callback_on_update):
		listeners.append(callback_on_update)
		wire_written(global_key, Wire.read(global_key))
	
	func wire_written(global_key, value):
		if self.global_key == global_key:
			for listener in listeners:
				listener.call(value)

	func write(value):
		Wire.write(global_key, value)

