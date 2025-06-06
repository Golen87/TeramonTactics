@tool
extends Node

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


@onready var monster_image: TextureRect = $MonsterImage
@onready var monster_type: TextureRect = $MonsterType
@onready var monster_name: Label = $MonsterName
@onready var health_label: Label = $HealthLabel
@onready var attack_label: Label = $AttackLabel
@onready var action_label: Label = $ActionLabel
@onready var frenzy_label: Label = $FrenzyLabel
@onready var attack_effect_label: Label = $AttackEffectLabel
@onready var ally_effect_label: Label = $AllyEffectLabel



func _on_monster_changed():
	if monster_definition:
		monster_image.texture = monster_definition.image
		#monster_type.texture = monster_definition.type
		monster_name.text = monster_definition.name
		health_label.text = str(monster_definition.health)
		attack_label.text = str(monster_definition.attack)
		action_label.text = str(monster_definition.action_points)
		frenzy_label.text = str(monster_definition.frency)
		attack_effect_label.text = monster_definition.description
		ally_effect_label.text = monster_definition.description
