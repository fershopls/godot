extends Camera2D

var t
func shake(qty = 8, duration = 0.15):
	if t:
		t.kill()
	t = create_tween()
	_shake_qty = qty
	t.tween_property(self, '_shake_qty', 0, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

var _shake_qty = 0
func _process(delta: float) -> void:
	if _shake_qty:
		var a = randf() * PI * 2
		var dir = Vector2(cos(a), sin(a))
		offset = _shake_qty * dir * randf()
	else:
		offset = Vector2.ZERO
