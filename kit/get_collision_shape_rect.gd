func get_collision_shape_rect(collision_shape: CollisionShape2D):
	var rectangle_shape: RectangleShape2D = collision_shape.shape
	var position = collision_shape.global_position - rectangle_shape.size / 2.0
	var size = rectangle_shape.size
	return Rect2(position, size)
