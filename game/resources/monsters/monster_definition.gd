@tool
class_name MonsterDefinition
extends Resource

#region persistent variables

@export_group("Visuals")
## Monster sprite
@export var image: Texture2D:
	get: return image
	set(value):
		image = value
		emit_changed()

@export_group("Details")
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

## Monster primary element
@export var element1: Element.Type:
	get: return element1
	set(value):
		element1 = value
		emit_changed()

## Monster secondary element
@export var element2: Element.Type:
	get: return element2
	set(value):
		element2 = value
		emit_changed()

@export_group("Stats")
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
@export_range(1, 10, 1) var fury: int:
	get: return fury
	set(value):
		fury = value
		emit_changed()

## Monster priority
@export_range(1, 100, 1) var speed: int:
	get: return speed
	set(value):
		speed = value
		emit_changed()


@export_group("Effects")
## Monster descriptive text
@export var offensive_description: String:
	get: return offensive_description
	set(value):
		offensive_description = value
		emit_changed()

## Monster descriptive text
@export var defensive_description: String:
	get: return defensive_description
	set(value):
		defensive_description = value
		emit_changed()

## Effects applied during combat
@export var effects: Array[Effect] = []

#endregion

#region transient variables

# Monster health points
var current_health: int = health:
	get: return current_health
	set(value):
		current_health = value
		emit_changed()

## Monster attack strength
var current_attack: int = attack:
	get: return current_attack
	set(value):
		current_attack = value
		emit_changed()

## The number of action points per turn
var current_action_points: int = action_points:
	get: return current_action_points
	set(value):
		current_action_points = value
		emit_changed()

## The number of attacks per turn
var current_fury: int = fury:
	get: return current_fury
	set(value):
		current_fury = value
		emit_changed()

## Monster priority
var current_speed: int = speed:
	get: return current_speed
	set(value):
		current_speed = value
		emit_changed()

var statuses: Dictionary[Element.Type, int]

#endregion

#region functions

func reset():
	current_health = health
	current_attack = attack
	current_action_points = action_points
	current_fury = fury
	current_speed = speed
	
	statuses.clear()

func add_status(_type: Element.Type, amount):
	if not statuses.has(_type):
		if amount > 0:
			statuses[_type] = amount
			emit_changed()
		return
	
	var new_amount = statuses[_type] + amount
	if new_amount > 0:
		statuses[_type] = new_amount
	else:
		statuses.erase(_type)
	
	emit_changed()

#endregion
