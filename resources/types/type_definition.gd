extends Resource
class_name TypeDefinition


## Type name
@export var name: String

## Type descriptive text
@export var description: String

## Type sprite
@export var image: Texture2D

## Type color
@export var color: Color

## Type buff or debuff
@export_enum("Buff", "Debuff") var is_buff: int
