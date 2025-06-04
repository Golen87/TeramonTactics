@tool
extends Node2D

@export var title: String = "Card Title"
@export var description: String = "Effect text here"
@export var cost: String = "1"

@onready var card_title: Label = %CardTitle
@onready var card_description: RichTextLabel = %CardDescription
@onready var card_cost: Label = %CardCost


func _ready() -> void:
	card_title.text = title
	card_description.text = description
	card_cost.text = cost
