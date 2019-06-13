extends Node

const PORT = 6969
const MAX_CLIENTS = 8

const rplayer_scn = preload("res://remote_player.tscn")

enum STATES {
	LOBBY,
	EXPECTING_MOVE,
	WAITING_FINISH
	}
var state = STATES.LOBBY

func _ready() -> void:
	#init server
	var inst = NetworkedMultiplayerENet.new()
	inst.create_server(PORT,MAX_CLIENTS)
	get_tree().set_network_peer(inst)
	
	get_tree().connect("network_peer_connected",self,"_on_peer_connect")
	get_tree().connect("network_peer_disconnected",self,"_on_peer_disconnect")



func _process(delta: float) -> void:
	match state:
		STATES.LOBBY:
			#lobby logic
			pass
		STATES.EXPECTING_MOVE:
			#recieving move
			pass
		STATES.WAITING_FINISH:
			#waiting
			pass

func _on_peer_connect(id:int)->void:
	print("Client ",id," connected!")
	var inst = rplayer_scn.instance()
	inst.name = str(id)
	get_tree().get_root().add_child(inst)

func _on_peer_disconnect(id:int)->void:
	print("Client ",id," connected!")
	get_tree().get_root().get_node(str(id)).queue_free()