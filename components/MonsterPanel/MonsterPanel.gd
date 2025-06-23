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
@onready var monster_element_1: TextureRect = $MonsterElement1
@onready var monster_element_2: TextureRect = $MonsterElement2
@onready var monster_name: Label = $MonsterName
@onready var health_label: Label = $HealthLabel
@onready var attack_label: Label = $AttackLabel
@onready var speed_label: Label = $SpeedLabel
@onready var action_label: Label = $ActionLabel
@onready var frenzy_label: Label = $FrenzyLabel
@onready var attack_effect_label: Label = $AttackEffectLabel
@onready var ally_effect_label: Label = $AllyEffectLabel



func _on_monster_changed():
	if monster_definition:
		monster_image.texture = monster_definition.image
		monster_name.text = monster_definition.name
		health_label.text = str(monster_definition.health)
		attack_label.text = str(monster_definition.attack)
		speed_label.text = str(monster_definition.speed)
		action_label.text = str(monster_definition.action_points)
		frenzy_label.text = str(monster_definition.frency)
		attack_effect_label.text = monster_definition.description
		ally_effect_label.text = monster_definition.description

		monster_element_1.visible = false
		if monster_definition.element1:
			monster_element_1.visible = true
			monster_element_1.texture = monster_definition.element1.image

		monster_element_2.visible = false
		if monster_definition.element2:
			monster_element_2.visible = true
			monster_element_2.texture = monster_definition.element2.image
