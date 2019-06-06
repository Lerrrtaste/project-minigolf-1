extends Node

onready var hole = get_node("Hole")
onready var ball_pos = get_node("BallPos")

const ball_scn = preload("res://ball.tscn")

var player_active:int
var player_inst:Array

func _ready() -> void:
	hole.connect("hole_hit", self, "_on_hole_hit")

func start_game(players:Array)->void:
	assert(players.size() > 0)
	player_inst = players
	player_active = 0
	for i in player_inst:
		var inst = ball_scn.instance()
		add_child(inst)
		i.ball = inst
		i.ball.position = ball_pos.position
		i.ball.player = i
	player_inst[player_active].ball.active = true # activate first player

func _on_hole_hit(body:PhysicsBody2D)->void:
	body.visible = false
	body.queue_free()

#TO BE OVERRIDEN BY SIBLING
#used for getting name in level selection
static func get_map_name()->String:
	return "No Name Set!"

func request_shoot(pos:Vector2)->void:
	yield(player_inst[player_active].ball.shoot(pos), "movement_finished")
	if(player_active == player_inst.size()-1):
		player_active = 0
	else:
		player_active += 1
	player_inst[player_active].ball.active = true

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_LEFT && event.pressed):
			request_shoot(event.position)

#DEBUG:
func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventKey):
		if(event.scancode == KEY_1 && event.pressed):
			pass