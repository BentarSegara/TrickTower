extends StaticBody2D

@export var required_puzzles: int = 2
@export var next_scene_path: String = ""
@export var auto_trigger_on_enter: bool = true
@export var circle_color: Color = Color(0.3, 0.6, 1.0) # default biru

@onready var circle_sprite: Sprite2D = $CircleSprite
@onready var rune_container: Node2D = $RuneContainer
@onready var detection_area: Area2D = $DetectionArea
@onready var anim: AnimationPlayer = $AnimationPlayer

var solved_count: int = 0
var activated: bool = false
var ascending: bool = false

func _ready() -> void:
	circle_sprite.modulate = circle_color
	_set_circle_visible(false)
	_set_runes_lit(0)

	detection_area.body_entered.connect(_on_body_entered)
	

func on_puzzle_solved() -> void:
	if activated:
		return

	solved_count += 1
	_set_runes_lit(solved_count)

	if solved_count >= required_puzzles:
		_activate_circle()


func _set_runes_lit(count: int) -> void:
	var lit := 0
	for child in rune_container.get_children():
		if child is Sprite2D:
			child.visible = lit < count
			lit += 1


func _set_circle_visible(on: bool) -> void:
	circle_sprite.visible = on


func _activate_circle() -> void:
	activated = true
	_set_circle_visible(true)

	if anim.has_animation("activate"):
		anim.play("activate")


func _on_body_entered(body: Node) -> void:
	if not auto_trigger_on_enter:
		return
	if not activated:
		return
	if ascending:
		return
	if not (body is CharacterBody2D):
		return

	_start_ascension(body)


func trigger(action_type: String) -> void:
	if not activated:
		return
	if ascending:
		return
	if action_type != "neutral":
		return

	var player := GameManager.player
	if player:
		_start_ascension(player)


func _start_ascension(player: CharacterBody2D) -> void:
	ascending = true
	player.velocity = Vector2.ZERO
	player.set_physics_process(false)

	if anim.has_animation("ascend"):
		anim.play("ascend")
		await anim.animation_finished
	else:
		await get_tree().create_timer(0.8).timeout

	_go_to_next_floor()


func _go_to_next_floor() -> void:
	if next_scene_path == "":
		return

	get_tree().change_scene_to_file(next_scene_path)
