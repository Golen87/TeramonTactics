class_name generic_animations

static var tween_map: Dictionary[Node, Tween]


# Plays a specific tween animation. Cancels existing tweens. Calls callback upon completion.
static func play(target: Node, animation: String, callback := Callable()) -> void:
	var new_tween
	if tween_map.has(target):
		tween_map[target].stop()

	match animation:
		"shake":
			new_tween = _play_shake(target)
		"hold":
			new_tween = _play_hold(target)
		"release":
			new_tween = _play_release(target)

	if callback.is_valid():
		new_tween.finished.connect(callback)
	tween_map[target] = new_tween


static func _play_shake(target: Node) -> Tween:
	var original_pos = target.position
	var shake_magnitude = 10.0
	var shake_duration = 0.03
	var steps = 6
	var tween := target.create_tween()\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	for i in range(steps):
		var direction = 1 if i % 2 == 0 else -1
		var offset = Vector2(shake_magnitude * direction, 0)
		tween.tween_property(target, "position", original_pos + offset, shake_duration)
		shake_magnitude *= 0.6  # Reduce magnitude
		shake_duration += 0.01  # Slow down

	# Final return to original position
	tween.tween_property(target, "position", original_pos, 0.05)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_QUAD)
	return tween


static func _play_hold(target: Node) -> Tween:
	var tween := target.create_tween()\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", Vector2(0.9, 0.9), 0.1)
	return tween


static func _play_release(target: Node) -> Tween:
	var tween := target.create_tween()\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", Vector2.ONE, 0.6)
	return tween


static func _play_bounce(target: Node) -> Tween:
	var tween := target.create_tween()\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(target, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(target, "scale", Vector2(1.0, 1.0), 0.1)
	return tween
