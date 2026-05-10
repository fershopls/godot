extends Object

func throw(
	node: Node2D,
	from: Vector2,
	to: Vector2,
	duration: float = 0.5,
	height: float = 150.0,
	rotate_to_velocity: bool = true
) -> Tween:
	node.visible = true
	node.global_position = from

	var last_pos := from

	var tween := node.create_tween()

	tween.tween_method(
		func(t: float):
			# Base linear movement
			var pos := from.lerp(to, t)

			# Arc
			var arc := sin(t * PI) * height
			pos.y -= arc

			# Apply position
			node.global_position = pos

			# Rotate toward movement
			if rotate_to_velocity:
				var dir := last_pos.direction_to(pos)
				if dir.length() > 0.001:
					node.rotation = dir.angle()

			last_pos = pos,
		0.0,
		1.0,
		duration
	)
	
	return tween
