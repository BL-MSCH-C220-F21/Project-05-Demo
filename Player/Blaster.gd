extends Spatial

var damage = 10
onready var Decal = load("res://Player/Decal.tscn")
onready var Pickup = load("res://Guns/Blaster.tscn")

func shoot():
	if not $Flash.visible:
		$Flash.show()
		$Flash/Timer.start()
		if $RayCast.is_colliding():
			var t = $RayCast.get_collider()
			var p = $RayCast.get_collision_point()
			var n = $RayCast.get_collision_normal()
			var decal = Decal.instance()
			t.add_child(decal)
			decal.global_transform.origin = p
			if n != Vector3.UP:
				decal.look_at(p + n, Vector3.UP)

	
func _on_Timer_timeout():
	$Flash.hide()
