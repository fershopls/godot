class_name Cooldown
extends Timer

func _init(parent, wait_time):
	self.one_shot = true
	self.wait_time = wait_time
	parent.add_child(self)

func is_ready():
	return is_stopped()
