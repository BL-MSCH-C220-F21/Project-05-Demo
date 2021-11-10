extends Spatial

onready var player1pos = $Player1Pos
onready var player2pos = $Player2Pos

func _ready():
	var player1 = preload("res://Player/Player.tscn").instance()
	player1.name = "Player1"
	player1.global_transform = player1pos.global_transform
	player1.id = get_tree().get_network_unique_id()
	player1.set_network_master(get_tree().get_network_unique_id())
	add_child(player1)

	var player2 = preload("res://Player/Player.tscn").instance()
	player2.name = "Player2"
	player2.id = Global.player2id
	player2.set_network_master(Global.player2id)
	player2.global_transform = player2pos.global_transform
	add_child(player2)
