extends Sprite3D

onready var bar = $Viewport/HealthBar2D
var bar_green = Color8(64,192,87)
var bar_yellow = Color8(255,212,59)
var bar_red = Color8(201,42,42)

func _ready():
	texture = $Viewport.get_texture()
	bar.set("custom_styles/fg",bar.get("custom_styles/fg").duplicate())


func update(h, max_h):
	bar.get("custom_styles/fg").bg_color = bar_green
	if h < 0.75 * max_h:
		bar.get("custom_styles/fg").bg_color = bar_yellow
	if h < 0.45 * max_h:
		bar.get("custom_styles/fg").bg_color = bar_red
	bar.value = h
