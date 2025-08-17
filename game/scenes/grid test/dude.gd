class_name Dude extends Area2D

signal clicked

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

enum DudeState {
	IDLE,
	WALKING,
	AIMING,
	SHOOTING,
	STUNNED,
}

# (1,0) right-down
# (0,1) left-down
# (-1,0) left-up
# (0,-1) right-up

var grid: Grid # TODO: Remove. Using it for funny dude behavior.
var cell: Vector2i = Vector2i()
var state := DudeState.IDLE
var facing := Vector2i(1, 0)
var recent_encounter: Dude = null


func _ready() -> void:
	timer.timeout.connect(set_state)
	update_sprite()

	on_idle_start()

func set_state():
	match state:
		DudeState.IDLE:
			on_idle_end()
		DudeState.WALKING:
			on_walk_end()
		DudeState.AIMING:
			on_aim_end()
		DudeState.SHOOTING:
			on_shoot_end()
		DudeState.STUNNED:
			on_stunned_end()

	match state:
		DudeState.IDLE:
			on_idle_start()
		DudeState.WALKING:
			on_walk_start()
		DudeState.AIMING:
			on_aim_start()
		DudeState.SHOOTING:
			on_shoot_start()
		DudeState.STUNNED:
			on_stunned_start()

	update_sprite()

func on_idle_start():
	timer.wait_time = randf_range(0.5, 4)
	timer.start()

func on_idle_end():
	var opponent = grid.get_monster(cell + facing)
	var neighbor: Dude = grid.get_neighboring_monster(cell)

	if opponent and opponent != recent_encounter and randf() < (1.0 if opponent.facing == (cell - opponent.cell) else 0.2):
		state = DudeState.AIMING
		return
	elif neighbor and neighbor != recent_encounter and randf() < (1.0 if neighbor.facing == (cell - neighbor.cell) else 0.3):
		facing = (neighbor.cell - cell)
		update_sprite()
		return
	else:
		var R = randf()
		if R < 0.3:
			facing = [Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN].pick_random()
			update_sprite()
		else:
			state = DudeState.WALKING

func on_walk_start():
	var cells := grid.get_available_cells(self)
	if cells.is_empty():
		return
	var new_cell: Vector2i = cells.pick_random()

	facing = (new_cell - cell)
	cell = new_cell

	var tween := create_tween()
	tween.tween_property(self, "position", grid.cell_to_world(new_cell), 0.7)
	var jump_tween = create_tween()
	#jump_tween.set_parallel(true)
	jump_tween.tween_property(sprite, "position:y", -75, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	jump_tween.tween_property(sprite, "position:y", -60, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	update_sprite()

	timer.wait_time = 0.7
	timer.start()

func on_walk_end():
	state = DudeState.IDLE

func on_aim_start():
	timer.wait_time = randf_range(1, 4)
	timer.start()

func on_aim_end():
	var opponent = grid.get_monster(cell + facing)
	if opponent:
		state = DudeState.SHOOTING
	else:
		state = DudeState.IDLE

func on_shoot_start():
	var opponent = grid.get_monster(cell + facing)
	if opponent:
		recent_encounter = opponent
		opponent.state = DudeState.STUNNED
		opponent.on_stunned_start()
		opponent.update_sprite()
		_play_shake(opponent.sprite)

	timer.wait_time = 0.5
	timer.start()

func on_shoot_end():
	state = DudeState.IDLE

func on_stunned_start():
	timer.wait_time = 2
	timer.start()

func on_stunned_end():
	state = DudeState.IDLE


func update_sprite():
	match state:
		DudeState.IDLE:
			sprite.frame = 0
		DudeState.WALKING:
			sprite.frame = 1
		DudeState.AIMING, DudeState.SHOOTING:
			sprite.frame = 2
		DudeState.STUNNED:
			sprite.frame = 3

	if facing.x < 0 or facing.y < 0:
		sprite.frame = sprite.frame + 4
	sprite.flip_h = facing.x > 0 or facing.y < 0


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	event = event as InputEventMouseButton
	if event and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Dude clicked!", self.cell)
		clicked.emit(self)
		#get_tree().set_input_as_handled()



func _play_shake(target: Node) -> Tween:
	var original_pos = target.position
	var shake_magnitude = 10.0
	var shake_duration = 0.05
	var steps = 8
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
