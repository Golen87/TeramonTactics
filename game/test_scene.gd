extends Node2D

@export var md: MonsterDefinition

@onready var timer = %Timer

var unit_1: MonsterDefinition
var unit_2: MonsterDefinition

var units: Array[Unit]

const unit_scene = preload("res://resources/units/zorua/unit_zorua.tscn")

func _ready():
	timer.timeout.connect(anim)
	timer.start()
	
	unit_1 = md.duplicate()
	unit_1.reset()
	unit_1.health += 10
	
	var new_unit = unit_scene.instantiate()
	add_child(new_unit)
	new_unit.position = Vector2(500,500)
	new_unit.unit_data = unit_1
	units.append(new_unit)
	
	unit_2 = md.duplicate()
	unit_2.reset()
	
	new_unit = unit_scene.instantiate()
	add_child(new_unit)
	new_unit.position = Vector2(1000,500)
	new_unit.unit_data = unit_2
	units.append(new_unit)

func anim():
	unit_1.current_health += 1
	
	var type = randi_range(0, len(Element.Type.keys()) - 1)
	if type > 0:
		unit_1.add_status(type, 1)
	
	for unit in units:
		var rand = randi_range(0, len(UnitSprite.UnitAnimation.values()) - 1)
		unit.sprite.play_animation(rand)
