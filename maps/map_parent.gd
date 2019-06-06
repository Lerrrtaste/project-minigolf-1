extends Node

onready var hole = get_node("Hole")
onready var ball_pos = get_node("BallPos")

const ball_scn = preload("res://ball.tscn")

var player_active:int
var player_ids:Array

signal finished

func _ready() -> void:
	hole.connect("hole_hit", self, "_on_hole_hit")
	player_active = 0
	player_ids = []
	for i in global.game.players:
		player_ids.append(i.id)
		#setup player
		i.playing = true
		#setup ball
		var inst = ball_scn.instance()
		add_child(inst)
		i.ball = inst
		i.ball.position = ball_pos.position
		i.ball.player_id = i.id
	global.game.player_get(player_ids[player_active]).ball.active = true # activate first player

#called from hole when ball(body) enters area
func _on_hole_hit(body:PhysicsBody2D)->void:
	global.game.player_get(body.player_id).playing = false
	var idx = player_ids.find(body.player_id)
	body.speed = 0.0

#NOT USED ATM
#TO BE OVERRIDEN BY SIBLING
#used for getting name in level selection
#static func get_map_name()->String:
#	return "No Name Set!"

func request_shoot(pos:Vector2)->void:
	if(global.game.player_get(player_ids[player_active]).ball.speed > 0): #if already moving, ignore request
		return
	yield(global.game.player_get(player_ids[player_active]).ball.shoot(pos), "movement_finished") #tell ball to move and wait for him to finish
	#make next player's ball active (ball deactivates itself)
	for i in player_ids.size():
		if(player_active == player_ids.size()-1):
			player_active = 0
		else:
			player_active += 1
		if(global.game.player_get(player_ids[player_active]).playing == true):
			global.game.player_get(player_ids[player_active]).ball.active = true
			return
	emit_signal("finished")

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_LEFT && event.pressed):
			request_shoot(event.position)

#DEBUG:
func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventKey):
		if(event.scancode == KEY_1 && event.pressed):
			pass