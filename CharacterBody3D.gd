extends CharacterBody3D

func _process(delta: float) -> void:
	var camera = $Camera3D
	var input = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var speed = 7
	
	var forward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x

	var direction = (right * input.x) + (forward * input.y)
	velocity = direction * speed
	move_and_slide()
