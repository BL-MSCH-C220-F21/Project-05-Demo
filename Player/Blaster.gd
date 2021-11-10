extends Spatial

var Decal = preload("res://Player/Decal.tscn")

func shoot():
	if not $Flash.visible and Global.ammo > 0:
		Global.update_ammo(-1)
		$Flash.show()
		$Flash/Timer.start()
		if $RayCast.is_colliding():
			var target = $RayCast.get_collider()
			var decal = Decal.instance()
			target.add_child(decal)
			decal.global_transform.origin = $RayCast.get_collision_point()
			decal.look_at($RayCast.get_collision_point() + $RayCast.get_collision_normal(), Vector3.UP)
			if target.has_method("die"):
				target.die()


func _on_Timer_timeout():
	$Flash.hide()
