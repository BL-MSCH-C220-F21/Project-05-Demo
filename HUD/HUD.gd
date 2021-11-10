extends Control

var blood_level = 0.0

func _ready():
	update()

func _physics_process(_delta):
	if Global.updated:
		Global.updated = false
		update()
	if Global.damaged:
		Global.damaged = false
		damaged()

func update():
	$Ammo.text = str(Global.ammo)
	$Health.text = str(Global.health) + "%"
	$Armor.text = str(Global.armor) + "%"
	
	if Global.health > 80:
		blood_level = 0.0
	elif Global.health > 50:
		blood_level = 0.1
	elif Global.health > 30:
		blood_level = 0.2
	elif Global.health > 10:
		blood_level = 0.3
	elif Global.health > 2:
		blood_level = 0.4
	else:
		blood_level = 0.8

	var t_portrait = "100"
	if Global.health > 80:
		t_portrait = "100"
	elif Global.health > 50:
		t_portrait = "80"
	elif Global.health > 30:
		t_portrait = "50"
	elif Global.health > 10:
		t_portrait = "30"
	else:
		t_portrait = "0"
	
	if $Portrait.animation != t_portrait:
		$Portrait.animation = t_portrait

func damaged():
	$Tween.interpolate_property($Blood, "color:a", 1.0, blood_level, 0.2, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
