@tool
extends Node2D

@export var monster_definition: MonsterDefinition:
	get: return monster_definition
	set(value):
		if monster_definition:
			monster_definition.changed.disconnect(_on_monster_changed)
		monster_definition = value
		if monster_definition:
			monster_definition.changed.connect(_on_monster_changed)
		if not is_node_ready():
			await ready
		_on_monster_changed()


@onready var monster_image: TextureRect = %MonsterImage


func _on_monster_changed():
	if monster_definition:
		monster_image.texture = monster_definition.image


# --- Input --- #

var is_held := false

func _on_button_button_down() -> void:
	is_held = true


func _on_button_button_up() -> void:
	is_held = false


func _process(delta: float) -> void:
	if is_held:
		global_position = get_global_mouse_position()
