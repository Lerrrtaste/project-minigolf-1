extends Area2D

const speed_max:int = 100
const friction:float = 1.0


var speed:int = 0
var direction:Vector2 = Vector2()

var preview_length:int = 0
var preview_direction:Vector2 = Vector2()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var collisions:Array = get_overlapping_areas()
	if(collisions.size()>0):
		for i in collisions:
			if(
			#check hitting wall
			#check touching hole
	
	position += direction.normalized() * speed 

#Called when clicked (+ player's turn)
#Player hit the ball
func hit(mouse_pos:Vector2)->void:
	speed = clamp(position.distance_to(mouse_pos),0,speed_max)
	direction = position.direction_to(mouse_pos)

#Called when mouse moved (+ player's turn)
#Updates the aim line var's and call's for redraw
#Call with Vector2() as param to hide
func update_preview(mouse_pos:Vector2)->void:
	preview_length = clamp(position.distance_to(mouse_pos),0,speed_max)
	preview_direction = position.direction_to(mouse_pos)
	update()

func _draw() -> void:
	draw_line(Vector2(),preview_direction*preview_length,ColorN("red"))

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(event.button_index == BUTTON_LEFT && event.pressed):
			hit(event.position)
	if(event is InputEventMouseMotion):
			update_preview(event.position) #TODO only if its the balls player's turn