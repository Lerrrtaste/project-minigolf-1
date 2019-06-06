extends Node

const menu_scn:PackedScene = preload("res://menu.tscn")
const player_scn = preload("res://player.gd")

var players:Array
var scene_current:Node
var player_id_next:int = 0

func _ready() -> void:
	assert(!is_instance_valid(global.game))
	global.game = self
	_on_map_finished()

#Called by menu scene when adding new player
#returns player id if succesful, otherwise -1
func player_create(nick:String)->int:
	for i in players:
		if(i.nick == nick):
			return -1
	var inst = player_scn.new()
	
	inst.nick = nick
	inst.id = player_id_next
	
	player_id_next += 1
	players.append(inst)
	return inst.id

#Called by menu scene when removing player
#returns true when player did exist
func player_remove(id:int)->bool:
	var inst
	for i in players.size()-1:
		if players[i].id == id:
			inst = players[i]
			players.remove(i)
	if(is_instance_valid(inst)):
		inst.free()
		return true
	return false

func player_get(id:int)->Object:
	for i in players:
		if(i.id == id):
			return i
	return null

#emitted by menu scene
#starts map in param
func _on_menu_play(map:PackedScene)->void:
	var inst = change_scene(map)
	inst.connect("finished",self,"_on_map_finished")

#emitted by map and called manually once in the beginning
#opens menu
func _on_map_finished()->void:
	var inst = change_scene(menu_scn)
	inst.connect("play",self,"_on_menu_play")

func change_scene(scene:PackedScene)->Object:
	if(is_instance_valid(scene_current)):
		if(scene_current is CanvasItem):
			scene_current.visible = false
		scene_current.queue_free()
	scene_current = scene.instance()
	add_child(scene_current)
	return scene_current