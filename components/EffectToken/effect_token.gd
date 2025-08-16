@tool
extends TextureRect
class_name EffectToken

@export var type: TypeDefinition:
	set(value):
		type = value
		if type:
			texture = type.image

@export var used := false:
	set(value):
		used = value
		modulate = Color(1, 1, 1, 0.5 if used else 1.0)


func _ready() -> void:
	texture = type.image
