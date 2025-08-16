extends Effect
class_name ApplyToken

## What element should be applied
@export var element: Element.Type

## How many tokens should be applied
@export_range(-10, 10) var amount: int = 1
