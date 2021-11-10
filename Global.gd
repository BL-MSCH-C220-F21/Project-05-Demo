extends Node

var armor = 100
var health = 100
var ammo = 50

var updated = false
var damaged = false

func _unhandled_input(_event):
	if Input.is_action_pressed("menu"):
		get_tree().quit()

func update_ammo(a):
	ammo += a
	updated = true

func update_damage(d):
	armor += d
	if armor < 0:
		health += armor
		damaged = true
		armor = 0
	if health < 0:
		pass
	updated = true
