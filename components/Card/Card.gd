@tool
extends Node2D

@export var title: String = "Card Title"
@export var description: String = "Effect text here"
@export var cost: String = "1"
@export var face_up: bool = true

@onready var card_back: TextureRect = %CardBack
@onready var card_front: TextureRect = %CardFront
@onready var card_title: Label = %CardTitle
@onready var card_description: RichTextLabel = %CardDescription
@onready var card_cost: Label = %CardCost


func _ready() -> void:
	card_back.visible = not face_up
	card_front.visible = face_up
	card_title.text = title
	card_description.text = description
	card_cost.text = cost


var is_held := false

func _on_button_button_down() -> void:
	is_held = true


func _on_button_button_up() -> void:
	is_held = false


func _process(delta: float) -> void:
	if is_held:
		global_position = get_global_mouse_position()
