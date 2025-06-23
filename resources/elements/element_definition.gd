extends Resource
class_name ElementDefinition


## Element name
@export var name: String

## Element descriptive text
@export var description: String

## Element sprite
@export var image: Texture2D

## Element color
@export var color: Color

## Element buff or debuff
@export_enum("Buff", "Debuff") var is_buff: int
