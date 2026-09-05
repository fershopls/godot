extends Camera3D

@export var mouse_sensitivity: float = 0.004

var yaw: float = 0.0
var pitch: float = 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity

		# Limit looking up/down
		pitch = clamp(pitch, -PI / 2.0, PI / 2.0)

		rotation.x = pitch
		rotation.y = yaw

	# Press ESC to release mouse
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
