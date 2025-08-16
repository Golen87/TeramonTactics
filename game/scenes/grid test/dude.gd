extends Node2D

@onready var sprite := $Sprite2D

func _ready() -> void:
	sprite.frame = randi_range(0, 5)
	sprite.flip_h = randf() < 0.5
