extends Node2D

onready var hole = get_node("Hole")

func _ready() -> void:
	hole.connect("hole_hit", self, "_on_hole_hit")

func _on_hole_hit(body:PhysicsBody2D)->void:
	body.visible = false
	body.queue_free()