extends Control

onready var list = get_node("ListNames")
onready var btn_remove = get_node("ListNames/ButtonRemove")
onready var btn_add = get_node("ListNames/TextName/ButtonAdd")
onready var btn_play = get_node("ButtonPlay")
onready var text = get_node("ListNames/TextName")

const player_scn = preload("res://player.tscn")

var selected_map_scn = preload("res://maps/map01.tscn") #hardcoded for debug

func _ready() -> void:
	text.text = ["John","Chris","Player","Karen"][randi()%4]
	btn_remove.connect("pressed",self,"_on_remove_pressed")
	btn_add.connect("pressed",self,"_on_add_pressed")
	btn_play.connect("pressed",self,"_on_play_pressed")

func _on_add_pressed()->void:
	if(text.text == ""):
		return
	var inst = player_scn.instance()
	inst.nick = text.text
	list.add_item(text.text)
	list.set_item_metadata(list.get_item_count()-1,inst)

func _on_remove_pressed()->void:
	var idx = list.get_selected_items()[0]
	var inst = list.get_item_metadata(idx)
	inst.queue_free()
	list.remove_item(idx)

func _on_play_pressed()->void:
	if(list.get_item_count() == 0):
		return
	var inst = selected_map_scn.instance()
	add_child(inst)
	var players:Array
	for i in list.get_item_count():
		players.append(list.get_item_metadata(i))
	inst.start_game(players)
	#get_tree().change_scene_to(inst)