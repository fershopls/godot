extends Node3D

"""
CameraPivot (Node3D) <- Script Here
	-> Camera3D
"""

@export var mouse_sensitivity: float = 0.004
@export var camera_distance: float = 5.0

var yaw: float = 0.0
var pitch: float = -0.3


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	$Camera3D.position.z = camera_distance


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity

		pitch = clamp(pitch, -PI / 2.0, PI / 2.0)

		# Orbit around the player
		rotation.y = yaw
		rotation.x = pitch

	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
