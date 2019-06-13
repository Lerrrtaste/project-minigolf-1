extends Control

onready var list_players = get_node("ListPlayers")
onready var list_maps = get_node("ListMaps")
onready var btn_remove = get_node("ListPlayers/ButtonRemove")
onready var btn_add = get_node("ListPlayers/TextName/ButtonAdd")
onready var btn_play = get_node("ButtonPlay")
onready var text = get_node("ListPlayers/TextName")

var selected_map_scn = preload("res://maps/map01.tscn") #hardcoded for debug
var names_example = ["John","Chris","Player","Karen"]
signal play(map) #destroys scene and starts map

func _ready() -> void:
	for i in global.game.players:
		list_players.add_item(i.nick)
		list_players.set_item_metadata(list_players.get_item_count()-1,i.id)
	
	names_example.shuffle()
	text.text = names_example.pop_front()
	
	btn_remove.connect("pressed",self,"_on_remove_pressed")
	btn_add.connect("pressed",self,"_on_add_pressed")
	btn_play.connect("pressed",self,"_on_play_pressed")
	
	update_maps()

func update_maps()->void:
	for i in global.maps:
		list_maps.add_item(i)
		list_maps.set_item_metadata(list_maps.get_item_count()-1, i)

func _on_add_pressed()->void:
	if(text.text == ""):
		return
	var id = global.game.player_create(text.text)
	if(id == -1):
		return
	list_players.add_item(text.text)
	list_players.set_item_metadata(list_players.get_item_count()-1,id)
	text.text = names_example.pop_front() if names_example.size()>0 else ""
	

func _on_remove_pressed()->void:
	if(list_players.get_selected_items().size() == 0):
		return
	var idx = list_players.get_selected_items()[0]
	var id = list_players.get_item_metadata(idx)
	global.game.player_remove(id)
	list_players.remove_item(idx)

func _on_play_pressed()->void:
	if(list_players.get_item_count() == 0 || list_maps.get_selected_items().size() == 0):
		return
	emit_signal("play",load(list_maps.get_item_metadata(list_maps.get_selected_items()[0])))