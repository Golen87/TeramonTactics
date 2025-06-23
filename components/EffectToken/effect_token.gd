@tool
extends TextureRect
class_name EffectToken

@export var element: ElementDefinition:
	set(value):
		element = value
		if element:
			texture = element.image

@export var used := false:
	set(value):
		used = value
		modulate = Color(1, 1, 1, 0.25 if used else 1.0)


func _ready() -> void:
	texture = element.image
