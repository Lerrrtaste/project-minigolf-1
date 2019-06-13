extends Node2D

const PORT = 6969

onready var btn_connect = get_node("btnConnect")
onready var text_nick = get_node("textNick")
onready var list_players = get_node("listPlayer")
onready var chk_ready = get_node("chkReady")

func _ready() -> void:
	btn_connect.connect("pressed",self,"_on_connect_pressed")
	chk_ready.connect("pressed",self,"_on_ready_toggled")
	
	get_tree().connect("connected_to_server",self,"_on_connected")
	get_tree().connect("connection_failed",self,"_on_connectionFailed")
	get_tree().connect("server_disconnected",self,"_on_disconnected")

remote func player_create(id:int,nick:String)->void:
	print("Creating Player: ",id, " with name ", nick)
	list_players.add_item(nick,null,false)
	list_players.set_item_metadata(list_players.get_item_count()-1,id)

remote func ready_update(id:int,ready:bool)->void:
	print("Recieved ready update for ",id," val:",ready)
	for i in list_players.get_item_count():
		if(list_players.get_item_metadata(i) == id):
			list_players.set_item_text(i,(list_players.get_item_text(i)+"(ready)") if (ready && !list_players.get_item_text(i).ends_with("(ready)")) else (list_players.get_item_text(i).replace("(ready)","")))
			break;

func _on_ready_toggled()->void:
	print("Sending ready update")
	rpc("ready_set",chk_ready.pressed)

func _on_connect_pressed()->void:
	assert(!is_instance_valid(get_tree().get_network_peer()))
	#connect
	var inst = NetworkedMultiplayerENet.new()
	inst.create_client("127.0.0.1",PORT)
	get_tree().set_network_peer(inst)

func _on_connected()->void:
	print("Connected successfully")
	name = str(get_tree().get_network_unique_id())
	rpc("player_creation_request",text_nick.text)
	btn_connect.visible = false
	text_nick.visible = false

func _on_connectionFailed()->void:
	print("Connection failed!")

func _on_disconnected()->void:
	print("Server disconnected!")