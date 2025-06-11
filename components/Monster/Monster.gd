@tool
extends Node2D
class_name Monster


@onready var monster_image: TextureRect = %MonsterImage
@onready var health_label: Label = %HealthLabel
@onready var attack_label: Label = %AttackLabel
@onready var effect_stack_container: HBoxContainer = %EffectStack

signal drag_started(monster: Monster)
signal drag_ended(monster: Monster)


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
		health_label.text = str(monster_definition.health)
		attack_label.text = str(monster_definition.attack)


var health: int = 0:
	set(value):
		health = value
		health_label.text = str(health)
var attack: int = 0:
	set(value):
		attack = value
		attack_label.text = str(attack)

@export var stacked_effects: Array[TypeDefinition]:
	set(value):
		stacked_effects = value
		_on_stacked_effects_update()

func add_stack_effect(effect: TypeDefinition):
	stacked_effects.append(effect)
	_on_stacked_effects_update()

func remove_stack_effect(index: int):
	stacked_effects.pop_at(index)
	_on_stacked_effects_update()

const effect_token = preload("res://components/EffectToken/EffectToken.tscn")

func _on_stacked_effects_update():
	if not effect_stack_container:
		return
	for child in effect_stack_container.get_children():
		child.queue_free()
	for effect in stacked_effects:
		var token = effect_token.instantiate()
		if effect:
			token.texture = effect.image
		effect_stack_container.add_child(token)
	if len(stacked_effects) > 1:
		var separation = (112 - 24 * len(stacked_effects)) / (len(stacked_effects) - 1)
		separation = min(separation, 8)
		effect_stack_container.add_theme_constant_override(&"separation", separation)


func _ready() -> void:
	health = monster_definition.health
	attack = monster_definition.attack

	_on_stacked_effects_update()

	#drag_button.pressed.connect(_on_drag_pressed)


# --- Input --- #

var is_held := false
var is_hovered := false

func _on_down() -> void:
	is_held = true
	emit_signal("drag_started", self)

func _on_up() -> void:
	is_held = false
	emit_signal("drag_ended", self)

func _on_enter() -> void:
	is_hovered = true

func _on_exit() -> void:
	is_hovered = false
