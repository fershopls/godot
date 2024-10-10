extends Node
"""
Use for connect dynamic nodes via children name:

1. Add a node with signature "WIRE_<local>_<global>"
example: WIRE_A_001

2. Use it for read / write values:
@onready var wire_feature = Wire.use(self, 'A')
wire_feature.write(value)
wire_feature.read(func (value): value)

3. Nodes will automatically react to each other via wires!
"""
signal wire_written(wire_global_key, value)

var _wires = {}

func use(node, wire_key):
	return WireInstance.new(node, wire_key)

func _write(wire_global_key, value):
	# resolve callback value with old value as param
	if typeof(value) == TYPE_CALLABLE:
		value = value.call(_wires.get(wire_global_key))
	
	_wires[wire_global_key] = value
	wire_written.emit(wire_global_key, value)

func _read(wire_global_key):
	return _wires.get(wire_global_key)

func clear_wires():
	_wires = {}

class WireInstance:
	var node: Node
	var wire_local_key
	var wire_global_key
	var listeners = []
	func _init(node, wire_local_key):
		self.node = node
		self.wire_local_key = wire_local_key
		self.wire_global_key = _get_wire_global_key()
		
		Wire.connect('wire_written', self._on_wire_written)
	
	func _get_wire_global_key():
		for node in node.get_children():
			var namespaces = node.name.split('_')
			
			if namespaces[0] != 'WIRE':
				continue
			
			var node_wire_local_key = namespaces[1]
			var node_wire_global_key = namespaces[2]
			
			if node_wire_local_key == self.wire_local_key:
				return node_wire_global_key
		return null
	
	func _on_wire_written(wire_global_key, value):
		if self.wire_global_key == wire_global_key:
			for listener in listeners:
				listener.call(value)

	func write(value):
		Wire._write(wire_global_key, value)
	
	func read(callback_on_update):
		listeners.append(callback_on_update)
		_on_wire_written(wire_global_key, Wire._read(wire_global_key))

