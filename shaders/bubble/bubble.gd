extends TextureRect

var SCREEN_SIZE = Vector2(1728, 972)

func _ready() -> void:
	visible = true
	m.set_shader_parameter('alpha', 0.0)

@onready var m: ShaderMaterial = material
var t: Tween
func bubble(at):
	m.set_shader_parameter('pos', at / SCREEN_SIZE)
	m.set_shader_parameter('aspect_ratio', SCREEN_SIZE.x / SCREEN_SIZE.y)
	
	if t:
		t.stop()
		t.kill()
	
	t = create_tween()
	t.tween_method(func (v): m.set_shader_parameter('progress', v), 0.0, 1.5, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	t.parallel().tween_method(func (v): m.set_shader_parameter('alpha', 1.0 - v), 0.0, 1.0, 0.6)
	t.tween_callback(func ():
		m.set_shader_parameter('progress', 0.0)
		m.set_shader_parameter('alpha', 0.0)
	)
	t.play()
