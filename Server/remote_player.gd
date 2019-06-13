extends Node

var setup:bool = false
var nick:String = "No name set"
var ready:bool = false

remote func ready_set(val:bool)->void:
	print(get_tree().get_rpc_sender_id(), " set ready to ", val)
	ready = val
	rpc("ready_update",get_tree().get_rpc_sender_id(),ready)

remote func player_creation_request(_nick:String)->void:
	print("Trying to register player with nick: ",_nick)
	#TODO check if already existing
	nick = _nick
	rpc("player_create",get_tree().get_rpc_sender_id(),nick)