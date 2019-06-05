extends KinematicBody2D

const hole_scn = preload("res://hole.tscn")

const speed_max:float = 400.0
const friction:float = 150.0

var speed:float = 0.0
var direction:Vector2 = Vector2()

var preview_length:int = 0
var preview_direction:Vector2 = Vector2()

onready var level = get_node("../")
onready var level_terrain = get_node("../Terrain")
onready var level_hole = get_node("../Hole")

enum COLLISION_TYPE {
		NOTHING = -1,
		HOLE = 0,
		WALL = 1
	}

enum COLLISION_SIDE {
		RIGHT = 0,
		BOTTOM = 1,
		LEFT = 2,
		TOP = 3
	}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
#	collision_step() #TODO only if player's turn, so that it self can control collisions with other balls
#	move(delta)

func _physics_process(delta: float) -> void:
	move(delta)

#Called from process
func move(delta:float)->void:
	speed = clamp(speed - friction*delta,0,speed_max)
	collision_handle(move_and_collide(direction.normalized() * speed * delta))
	#position += direction.normalized() * speed * delta

##Called from process
##checks for collision on all sides
#func collision_step()->void:
#	collision_test(COLLISION_SIDE.RIGHT) # check collision right
#	collision_test(COLLISION_SIDE.BOTTOM)# check collision bottom
#	collision_test(COLLISION_SIDE.LEFT)# check collision left
#	collision_test(COLLISION_SIDE.TOP)# check collision top
#
##Called from collision_step for all sides
##tests tilemap for "wall" and overlappingarea for collision
##returns COLLISION_TYPE
#func collision_test(side:int)->void:
#	var tex_size = get_node("Sprite").texture.get_size()
#	var test_offset:Vector2
#	match side:
#		COLLISION_SIDE.RIGHT:
#			test_offset = Vector2(tex_size.x/2,0)
#		COLLISION_SIDE.BOTTOM:
#			test_offset = Vector2(0,tex_size.y/2)
#		COLLISION_SIDE.LEFT:
#			test_offset = Vector2(-tex_size.x/2,0)
#		COLLISION_SIDE.TOP:
#			test_offset = Vector2(0,-tex_size.y/2)
#	var tm_pos:Vector2 = level_terrain.world_to_map(position+test_offset)
#	for i in get_overlapping_areas(): # check for area2d collisions (holes only rn)
#		collision_handle(COLLISION_TYPE.HOLE, side, i)
#		#TODO add check for other balls
#	if(level_terrain.tile_set.tile_get_name(level_terrain.get_cellv(tm_pos)) == "wall"): #check for wall collision
#		collision_handle(COLLISION_TYPE.WALL, side)
#
#called from collision_step for every collision test
#func collision_handle(collision_type:int, collision_side:int, colliding_area:Area2D = null)->void:
#	match collision_type:
#		COLLISION_TYPE.NOTHING:
#			return
#		COLLISION_TYPE.HOLE:
#			print("Colliding with hole!")
#		COLLISION_TYPE.WALL:
#			print("Colliding with wall")
#			if(collision_side == COLLISION_SIDE.LEFT || collision_side == COLLISION_SIDE.RIGHT):
#				direction.x = -direction.x
#			else:
#				direction.y = -direction.y
#		_:
#			print("WARNING: unknown collision type: %s"%collision_type)

#called from move() when colliding
func collision_handle(collision:KinematicCollision2D)->void:
	if(!is_instance_valid(collision)):
		return
	if(collision.collider is TileMap):
		var tm_pos:Vector2 = level_terrain.world_to_map(collision.position)
		tm_pos += direction.normalized()*0.1
		if(level_terrain.tile_set.tile_get_name(level_terrain.get_cellv(tm_pos)) == "wall"): #check for wall collision
			print("Colliding with wall")
			#determine side
			var delta:Vector2
#			delta.x = position.x - level_terrain.map_to_world(tm_pos).x+level_terrain.cell_size.x/2
#			delta.y = position.y - level_terrain.map_to_world(tm_pos).y+level_terrain.cell_size.y/2
			delta.x = position.x - collision.position.x
			delta.y = position.y - collision.position.y
			if(abs(delta.x) > abs(delta.y)):
				direction.x = -direction.x
			else:
				direction.y = -direction.y

#Called when clicked (+ player's turn)
#Player shoots the ball
func shoot(mouse_pos:Vector2)->void:
	speed = clamp(position.distance_to(mouse_pos),0,100) * (speed_max/100)
	direction = position.direction_to(mouse_pos)

#Called when mouse moved (+ player's turn)
#Updates the aim line var's and call's for redraw
#Call with Vector2() as param to hide
func update_preview(mouse_pos:Vector2)->void:
	preview_length = clamp(position.distance_to(mouse_pos),0,100)
	preview_direction = position.direction_to(mouse_pos)
	update()

func _draw() -> void:
	draw_line(Vector2(),preview_direction*preview_length,ColorN("red"))

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_LEFT && event.pressed):
			shoot(event.position)
	if(event is InputEventMouseMotion):
			update_preview(event.position) #TODO only if its the balls player's turn

func point_in_rect(point:Vector2, rect:Rect2)->bool:
	return (point.x >= rect.position.x &&point.y >= rect.position.y && point.x <= rect.position.x+rect.size.x && point.y <= rect.position.y+rect.size.y)