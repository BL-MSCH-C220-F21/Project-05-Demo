extends Control

func _ready():
	var _connect = get_tree().connect("network_peer_connected", self, "_player_connected")


func _on_Host_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_server(12345, 2)
	get_tree().set_network_peer(net)
	print("Hosting a new connection")
	Global.which_player = 1


func _on_Join_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_client("127.0.0.1", 12345)
	get_tree().set_network_peer(net)
	Global.which_player = 2


func _player_connected(id):
	Global.player2id = id
	var game = preload("res://Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
