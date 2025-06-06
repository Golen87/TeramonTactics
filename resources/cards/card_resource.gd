@tool
class_name CardDefinition
extends Resource


## The card title.
@export var name: String = "":
	get: return name
	set(value):
		name = value
		emit_changed()

## The effect text on the lower half of the card.
@export var description: String = "":
	get: return description
	set(value):
		description = value
		emit_changed()

## The card image on the upper half of the card.
@export var image: Texture2D:
	get: return image
	set(value):
		image = value
		emit_changed()

## The cost to play the card
@export_range(1, 10, 1) var cost: int:
	get: return cost
	set(value):
		cost = value
		emit_changed()
