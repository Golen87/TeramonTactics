extends Resource
class_name StatDefinition


## Element type
@export var type: Element.StatType

## Element name
@export var name: String

## Element descriptive text
@export var description: String

## Element sprite
@export var image: Texture2D

## Element color
@export var color: Color

func _to_string() -> String:
	return name
