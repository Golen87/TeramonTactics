class_name UnitSprite extends Area2D

enum UnitAnimation {IDLE, WALK, ATTACK, HIT}

@onready var sprite: Sprite2D = %Sprite
@onready var collision: CollisionShape2D = %Collision
@onready var animation_player: AnimationPlayer = %AnimationPlayer

var col: CollisionShape2D

var animation_library_name: String = ""

const SPRITESHEET_CELL_SIZE = Vector2(256, 384)
const SPRITESHEET_DIMENSIONS = Vector2(4, 3)

func _ready():
	for library in animation_player.get_animation_library_list():
		if library != "":
			animation_library_name = library

func play_animation(_animation: UnitAnimation):
	var anim_name = animation_library_name + "/" + UnitAnimation.keys()[_animation].to_lower()
	print(anim_name)
	if animation_player.has_animation(anim_name):
		print("play!")
		animation_player.play(anim_name)

func set_sprite_scale(_scale: float):
	sprite.scale = Vector2(_scale, _scale)
