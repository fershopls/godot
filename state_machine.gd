extends Node
class_name StateMachine

"""
enum State {
	IDLE,
	PATROL,
	ALERT,
	CHASE,
	DEATH,
}

@onready var state = StateMachine.new(self, State)

func _idle_physics(delta):
	pass

func _patrol_process(delta):
	pass
"""

signal change(from, to)
signal changed(from, to)

var debug: bool = false

var states: Dictionary
var current_state: int = -1
var initial_state: int = -1
var time_in_state: float

var _state_history = []

func _init(parent: Node, states: Dictionary, initial_state: int = 0):
	self.states = states
	self.initial_state = initial_state
	parent.add_child(self)

func _ready():
	await get_tree().process_frame
	await get_tree().process_frame
	go(initial_state)

func enable_think(interval: float = 0.5, callback_name = ''):
	# create timer
	var timer = Timer.new()
	timer.wait_time = interval
	add_child(timer)
	timer.start()
	
	# connect
	if callback_name:
		callback_name = 'think_' + callback_name
	else:
		callback_name = 'think'
	
	timer.connect('timeout', _on_Think_timeout.bindv([callback_name]))

func _on_Think_timeout(callback_name):
	call_parent_state_method('_' + callback_name)
	call_parent_method('_' + callback_name, [])

func get_current_state_name():
	return get_state_name(current_state)

func call_parent_state_method(suffix: String, arguments: Array = []):
	var name = get_current_state_name()
	if not name:
		return

	var method = '_' + name.to_lower() + suffix
	call_parent_method(method, arguments)

func call_parent_method(method: String, arguments: Array):
	var parent = get_parent()
	
	if not parent.has_method(method):
		return
	
	parent.callv(method, arguments)

func get_state_name(state):
	for state_key in states.keys():
		var state_value = states[state_key]
		if state_value == state:
			return state_key
	return null

func go(new_state: int):
	var old_state = current_state
	
	if new_state == old_state:
		return
	
	emit_signal('change', old_state, new_state)
	
	_on_exit(old_state, new_state)
	current_state = new_state
	_on_enter(old_state, new_state)
	
	emit_signal('changed', old_state, new_state)

func safe_go(from, to):
	if at(from):
		go(to)

func at(state):
	if state is Array:
		for value in state:
			if at(value):
				return true
		
		return false
	
	return current_state == state

func wait(time: float):
	var timer = get_tree().create_timer(time)
	return timer.timeout

func _debug_process():
	var parent = get_parent()
	if not parent.has_node('state_debug'):
		var label = Label.new()
		label.name = 'state_debug'
		label.global_position.y -= 50
		parent.add_child(label)
	
	var label = parent.get_node('state_debug')
	var state_name = get_state_name(current_state)
	
	if not state_name:
		state_name = 'unknown'
	
	label.text = state_name

func _push_history(new):
	_state_history.append(new)
	if _state_history.size() > 60:
		_state_history.resize(50)

func _on_exit(old, new):
	call_parent_state_method('_exit', [])
	time_in_state = 0

func _on_enter(old, new):
	_push_history(new)
	call_parent_state_method('_enter', [])

func _process(delta):
	call_parent_state_method('_process', [delta])
	
	if debug:
		_debug_process()

func _physics_process(delta):
	time_in_state += delta
	call_parent_state_method('_physics', [delta])
