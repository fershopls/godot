extends Object
class_name Buffer

"""
# Firerate example:
var _buffer = Buffer.new(400)
if not _buffer.is_queued():
	_buffer.queue()
	# attack()
"""

var ttl_ms: int
var queued_at: int

func _init(ttl_ms: int = 60):
	self.ttl_ms = ttl_ms

func queue():
	queued_at = _now()

func is_queued():
	return _now() - queued_at <= ttl_ms

func clear():
	queued_at = 0

func _now():
	return Time.get_ticks_msec()
