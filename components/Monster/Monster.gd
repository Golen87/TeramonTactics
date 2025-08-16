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

const effect_token = preload("res://components/EffectToken/EffectToken.tscn")


# Monsters would never normally spawn with tokens, so this is purely used during testing
@export var debug_stacked_effects: Array[TypeDefinition]:
	set(value):
		debug_stacked_effects = value
		if Engine.is_editor_hint():
			_on_debug_stacked_effects_update()
func _on_debug_stacked_effects_update():
	if not effect_stack_container:
		return
	for child in effect_stack_container.get_children():
		effect_stack_container.remove_child(child)
		child.queue_free()
	for type in debug_stacked_effects:
		if type:
			var token = effect_token.instantiate()
			token.type = type
			effect_stack_container.add_child(token)
	_rearrange_tokens()


# --- Effect tokens --- #

func add_stack_effect(type: TypeDefinition):
	var token = effect_token.instantiate()
	token.type = type
	effect_stack_container.add_child(token)
	_rearrange_tokens()

#func remove_stack_effect(index: int):
	#stacked_effects.pop_at(index)
	#_rearrange_tokens()


func _rearrange_tokens():
	var tokens = effect_stack_container.get_children()
	if len(tokens) > 1:
		var separation = (112 - 24 * len(tokens)) / (len(tokens) - 1)
		separation = min(separation, 8)
		effect_stack_container.add_theme_constant_override(&"separation", separation)


func _ready() -> void:
	if monster_definition:
		health = monster_definition.health
		attack = monster_definition.attack

	_on_debug_stacked_effects_update()

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
