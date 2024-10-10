extends Timer
class_name TimerBuffer

static func create(parent, ttl = 0.06):
	var instance = new()
	instance.one_shot = true
	instance.wait_time = ttl
	parent.add_child(instance)
	return instance

func queue(ttl = -1):
	start(ttl)

func is_queued():
	return not is_stopped()

func clear():
	stop()
