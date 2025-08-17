class_name Unit extends Node2D

signal clicked

@onready var sprite: UnitSprite = %UnitSprite

@export var unit_data: MonsterDefinition:
	get: return unit_data
	set(value):
		unit_data = value
		_set_unit_data(unit_data)

func _ready():
	sprite.mouse_entered.connect(_on_mouse_entered)
	sprite.mouse_exited.connect(_on_mouse_exited)
	pass

func _set_unit_data(_unit_data: MonsterDefinition):
	if not is_node_ready(): await ready
	
	sprite.play_animation(UnitSprite.UnitAnimation.IDLE)

func _on_mouse_entered():
	print("test")
func _on_mouse_exited():
	print("test")

func _input(event):
	if event is InputEventMouseButton and event.is_released():
		print("click!")
