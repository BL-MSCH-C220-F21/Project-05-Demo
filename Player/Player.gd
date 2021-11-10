extends KinematicBody

onready var camera = $Pivot/Camera
onready var Decal = load("res://Player/Decal.tscn")

var speed = 5
var gravity = -8.0
var direction = Vector3()
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var velocity = Vector2.ZERO

var controlled = false 

var id = 0

var damage = 10
var health = 100
var max_health = 100


func _ready():
	if (name == "Player1" and Global.which_player == 1) or (name == "Player2" and Global.which_player == 2):
		controlled = true
		$Pivot/Camera.current = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$MeshInstance.set_surface_material(0, $MeshInstance.get_surface_material(0).duplicate())
	if name == "Player1":
		$MeshInstance.get_surface_material(0).albedo_color = Color8(34, 139, 230)
	else:
		$MeshInstance.get_surface_material(0).albedo_color = Color8(250, 82,82, 230)	

func _physics_process(_delta):
	if controlled:
		velocity = get_input()*speed
		velocity.y += gravity
		if is_on_floor():
			velocity.y = 0

		if velocity != Vector3.ZERO:
			velocity = move_and_slide(velocity, Vector3.UP)
			rpc_unreliable("_set_position", global_transform.origin)
		
		if Input.is_action_pressed("shoot"):
			shoot()

func _input(event):
	if controlled and event is InputEventMouseMotion:
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)
		rpc_unreliable("_set_rotation", rotation, $Pivot.rotation)

func get_input():
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("right"):
		input_dir += camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func shoot():
	if not $Pivot/Flash.visible:
		$Pivot/Flash.show()
		$Pivot/Flash/Timer.start()
		var target = ""
		if $Pivot/RayCast.is_colliding():
			var t = $Pivot/RayCast.get_collider()
			var p = $Pivot/RayCast.get_collision_point()
			var n = $Pivot/RayCast.get_collision_normal()
			var decal = Decal.instance()
			t.add_child(decal)
			decal.global_transform.origin = p
			decal.look_at(p + n, Vector3.UP)
			if t.has_method("damaged"):
				target = t.get_path()
				t.damaged(damage)
		rpc_unreliable("_shoot", target, damage)

func damaged(d):
	health -= d
	$HealthBar.update(health, max_health)
	if health <= 0:
		if controlled:
			var _scene = get_tree().change_scene("res://UI/Die.tscn")
		else:
			var _scene = get_tree().change_scene("res://UI/Win.tscn")
		get_node("/root/Game").hide()
			


remote func _set_position(pos):
	if not controlled:
		global_transform.origin = pos

remote func _set_rotation(rot, piv_rot):
	if not controlled:
		rotation = rot
		$Pivot.rotation = piv_rot

remote func _shoot(target, d):
	if not controlled:
		$Pivot/Flash.show()
		$Pivot/Flash/Timer.start()
		if target != "":
			get_node(target).damaged(d)

func _on_Timer_timeout():
	$Pivot/Flash.hide()
