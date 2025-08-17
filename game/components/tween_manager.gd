class_name TweenManager extends Node

enum TweenType {WIGGLE, JUMP, FLINCH}

func _ready():
	pass

static func do_tween(_target: Node, _type: TweenType):
	var tween = _target.create_tween()
	match _type:
		TweenType.WIGGLE:
			tween.set_ease(Tween.EASE_IN)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(_target, "scale", Vector2(2.0, 2.0), 1.0)
			print("test")
