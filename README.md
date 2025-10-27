# Frame independant lerp
var speed = 1.0 # 0 to 1 per second
value = lerp(value, target_value, 1.0 - exp(-speed * delta))
