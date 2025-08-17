@tool 
class_name NumberedBadge extends Control

@onready var sprite = %Sprite
@onready var amount_text = %AmountText

@export var attribute: Resource:
	get: return attribute
	set(value):
		attribute = value
		_update()
@export var amount: int:
	get: return amount
	set(value):
		amount = value
		_update()

func _update():
	if not is_node_ready(): await ready
	
	var is_status: bool = attribute is ElementDefinition
	var valid = (is_status or attribute is StatDefinition) and not (is_status and amount <= 0)
	visible = valid
	if !valid: return
	
	amount_text.text = str(amount)
	sprite.texture = attribute.image
