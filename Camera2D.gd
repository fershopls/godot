extends Camera2D

var t
func shake(qty = 8, duration = 0.2):
	if t:
		t.kill()
	t = create_tween()
	shake_qty = qty
	t.tween_property(self, 'shake_qty', 0, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

var shake_qty = 0
func _process(delta: float) -> void:
	if shake_qty:
		var a = randf() * PI * 2
		var dir = Vector2(cos(a), sin(a))
		offset = shake_qty * dir * randf()
