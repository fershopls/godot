extends Timer
class_name Buffer

var ttl: int
var queued_at: int

func _init(ttl: int = 60):
	self.ttl = ttl

func queue():
	queued_at = now()

func is_queued():
	return now() - queued_at <= ttl

func clear():
	queued_at = 0

func now():
	return Time.get_ticks_msec()
