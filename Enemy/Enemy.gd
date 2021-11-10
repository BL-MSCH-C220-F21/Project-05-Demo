extends Area

var damaging = false
export var damage = 1

func _physics_process(_delta):
	if damaging:
		Global.update_damage(-damage)


func _on_Enemy_body_entered(body):
	if body.name == "Player":
		damaging = true


func _on_Enemy_body_exited(body):
	if body.name == "Player":
		damaging = false
