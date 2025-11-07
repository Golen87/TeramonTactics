class_name Dude extends Area2D

signal clicked

@onready var sprite: Sprite2D = $Sprite2D

enum DudeState {
	IDLE,
	WALKING,
	AIMING,
	SHOOTING,
	STUNNED,
}

var cell: Vector2i = Vector2i()
var state := DudeState.IDLE
var facing := Vector2i(1, 0)
var selected := false


func _ready() -> void:
	face_random_direction()
	set_state(DudeState.IDLE)

func _process(_delta: float) -> void:
	if state == DudeState.IDLE and randf() < 0.001:
		face_random_direction()


func face_random_direction():
	const directions = [Vector2i.UP, Vector2i.LEFT, Vector2i.RIGHT, Vector2i.DOWN]
	facing = directions.pick_random()
	update_sprite()

# Calculate facing direction
# (1,0) right-down
# (0,1) left-down
# (-1,0) left-up
# (0,-1) right-up
func get_facing_direction(dir: Vector2) -> Vector2i:
	if sign(dir.y) > 0:
		return Vector2i(1, 0) if sign(dir.x) > 0 else Vector2i(0, 1)
	return Vector2i(0, -1) if sign(dir.x) > 0 else Vector2i(-1, 0)

func move_along_path(path: Array[Vector2]):
	for cell in path.slice(1):
		move(cell)
		# TODO: Improve on this hack. Probably make a long tween chain instead.
		await get_tree().create_timer(0.8).timeout
	# TODO: Add signal here. Finished walking along path.

func move(new_position: Vector2):
	facing = get_facing_direction(new_position - position)
	set_state(DudeState.WALKING)

	# Linear interpolation of position
	var tween := create_tween()
	tween.tween_property(self, "position", new_position, 0.7)
	tween.finished.connect(func(): set_state(DudeState.IDLE))

	# Jump height
	var jump_tween = create_tween()
	jump_tween.tween_property(sprite, "position:y", -75, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	jump_tween.tween_property(sprite, "position:y", -60, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)


func set_state(_state: DudeState):
	state = _state
	update_sprite()

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


# Detect clicks
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	event = event as InputEventMouseButton
	if event and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Dude clicked!", self.cell)
		clicked.emit(self)
		generic_animations._play_bounce(self)
		#get_tree().set_input_as_handled()
