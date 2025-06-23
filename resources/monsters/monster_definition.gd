@tool
class_name MonsterDefinition
extends Resource


## Monster name
@export var name: String:
	get: return name
	set(value):
		name = value
		emit_changed()

## Monster descriptive text
@export var description: String:
	get: return description
	set(value):
		description = value
		emit_changed()

## Monster sprite
@export var image: Texture2D:
	get: return image
	set(value):
		image = value
		emit_changed()

## Monster primary element
@export var element1: ElementDefinition:
	get: return element1
	set(value):
		element1 = value
		emit_changed()

## Monster secondary element
@export var element2: ElementDefinition:
	get: return element2
	set(value):
		element2 = value
		emit_changed()

# Monster health points
@export_range(1, 100, 1) var health: int:
	get: return health
	set(value):
		health = value
		emit_changed()

## Monster attack strength
@export_range(1, 10, 1) var attack: int:
	get: return attack
	set(value):
		attack = value
		emit_changed()

## The number of action points per turn
@export_range(1, 10, 1) var action_points: int:
	get: return action_points
	set(value):
		action_points = value
		emit_changed()

## The number of attacks per turn
@export_range(1, 10, 1) var frency: int:
	get: return frency
	set(value):
		frency = value
		emit_changed()

## Monster priority
@export_range(1, 100, 1) var speed: int:
	get: return speed
	set(value):
		speed = value
		emit_changed()
