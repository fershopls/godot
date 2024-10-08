class_name Kit
extends Node

static func chance(value: float):
	return randf() < value

static func rand_sign():
	return -1 if chance(0.5) else 1

static func rand_angle():
	return randf() * PI * 2.0

static func rand_direction():
	return Vector2.from_angle(rand_angle())

static func get_collision_shape_rect(collision_shape: CollisionShape2D):
	var rectangle_shape: RectangleShape2D = collision_shape.shape
	var position = collision_shape.global_position - rectangle_shape.size / 2.0
	var size = rectangle_shape.size
	return Rect2(position, size)

static func center(node: Node2D):
	var center = node.get_node_or_null('Center')
	
	if center:
		return center.global_position
	
	return node.global_position

static func copy_camera_limits(from: Camera2D, to: Camera2D):
	to.limit_top = from.limit_top
	to.limit_bottom = from.limit_bottom
	to.limit_left = from.limit_left
	to.limit_right = from.limit_right

static func timestamp():
	return int(Time.get_unix_time_from_system())

static func wait(wait_time: float):
	var timer = Engine.get_main_loop().create_timer(wait_time)
	return timer.timeout

static func calculate_acceleration(speed: float, time: float):
	return float(speed) / float(time)

static func calculate_jump_force_by_height_and_time(height: float, time: float):
	var gravity = - ((2.0 * height) / pow(time, 2.0))
	var jump_force = -gravity * time
	return [gravity, jump_force]

static func get_parent_in_group(node: Node, group_name: String):
	while true:
		if node.is_in_group(group_name):
			break
		
		var parent = node.get_parent()
		
		if parent as Node:
			node = parent
			continue
		
		node = null
		break
	
	return node

static func particles_disable(node_container: Node):
	node_container.visible = false
	for node in node_container.get_children():
		if node as GPUParticles2D:
			node.restart()
			node.emitting = false

static func particles_one_shot(node_container: Node):
	node_container.visible = true
	for node in node_container.get_children():
		if node as GPUParticles2D:
			node.restart()
			node.emitting = true
			node.one_shot = true

static func model_pull(node_model: Node):
	var node = node_model.duplicate()
	node_model.queue_free()
	return node

static func model_instanciate(model: Node):
	return model.duplicate()
