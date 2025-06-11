@tool
extends Node2D
class_name Card


@export var face_up: bool = true
@export var card_definition: CardDefinition:
	get: return card_definition
	set(value):
		if card_definition:
			card_definition.changed.disconnect(_on_card_changed)
		card_definition = value
		if card_definition:
			card_definition.changed.connect(_on_card_changed)
		if not is_node_ready():
			await ready
		_on_card_changed()


@onready var card_back: TextureRect = %CardBack
@onready var card_front: TextureRect = %CardFront
@onready var card_image: TextureRect = %CardImage
@onready var card_title: Label = %CardTitle
@onready var card_description: RichTextLabel = %CardDescription
@onready var card_cost: Label = %CardCost


func _on_card_changed():
	if card_definition:
		card_image.texture = card_definition.image
		card_title.text = card_definition.name
		card_description.text = card_definition.description
		card_cost.text = str(card_definition.cost)


func _ready() -> void:
	card_back.visible = not face_up
	card_front.visible = face_up


# --- Input --- #

var is_held := false

func _on_button_button_down() -> void:
	is_held = true


func _on_button_button_up() -> void:
	is_held = false


func _process(delta: float) -> void:
	if is_held:
		global_position = get_global_mouse_position()
