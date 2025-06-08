@tool
extends Node2D


@onready var monster_image: TextureRect = %MonsterImage
@onready var health_label: Label = %HealthLabel
@onready var attack_label: Label = %AttackLabel
@onready var effect_stack_container: HBoxContainer = %EffectStack


@export var monster_definition: MonsterDefinition:
	get: return monster_definition
	set(value):
		if monster_definition:
			monster_definition.changed.disconnect(_on_definition_changed)
		monster_definition = value
		if monster_definition:
			monster_definition.changed.connect(_on_definition_changed)
		if not is_node_ready():
			await ready
		_on_definition_changed()

func _on_definition_changed():
	if monster_definition:
		monster_image.texture = monster_definition.image
		health = monster_definition.health
		attack = monster_definition.attack


@export var health: int:
	set(value):
		health = value

@export var attack: int:
	set(value):
		attack = value

@export var stacked_effects: Array[TypeDefinition]:
	set(value):
		stacked_effects = value


const effect_token = preload("res://components/EffectToken/EffectToken.tscn")

func _ready() -> void:
	health = monster_definition.health
	attack = monster_definition.attack
	health_label.text = str(health)
	attack_label.text = str(attack)
	for child in effect_stack_container.get_children():
		child.queue_free()
	for effect in stacked_effects:
		var token = effect_token.instantiate()
		token.texture = effect.image
		effect_stack_container.add_child(token)
	var separation = (effect_stack_container.size[0] - 24 * len(stacked_effects)) / (len(stacked_effects) - 1)
	separation = min(separation, 8)
	effect_stack_container.add_theme_constant_override(&"separation", separation)


# --- Input --- #

var is_held := false

func _on_button_button_down() -> void:
	is_held = true


func _on_button_button_up() -> void:
	is_held = false


func _process(delta: float) -> void:
	if is_held:
		global_position = get_global_mouse_position()
