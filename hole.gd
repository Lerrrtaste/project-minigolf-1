extends Area2D

onready var level = get_node("../")

signal hole_hit(body)

func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body:PhysicsBody2D)->void:
	emit_signal("hole_hit", body)