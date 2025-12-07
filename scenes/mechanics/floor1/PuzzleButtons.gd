extends Node2D

@export var circle_path: NodePath   # drag AscensionCircle di Floor1 ke sini

@onready var circle = get_node(circle_path)

var pattern: Array[int] = []
var current_step: int = 0
var solved: bool = false

func _ready() -> void:
	# connect ketiga pad
	for child in get_children():
		if child.has_signal("pad_pressed"):
			child.connect("pad_pressed", Callable(self, "_on_pad_pressed"))

	_generate_pattern()

func _generate_pattern() -> void:
	# 0,1,2 acak; kalau mau urutan fix, ubah ini
	pattern = [0, 1, 2]
	pattern.shuffle()
	current_step = 0
	solved = false
	# nanti: update visual hint di dinding

func _on_pad_pressed(pad_id: int) -> void:
	if solved:
		return

	if pad_id == pattern[current_step]:
		current_step += 1
		if current_step >= pattern.size():
			_on_solved()
	else:
		_reset()

func _reset() -> void:
	current_step = 0
	# tambahkan sfx / efek reset bila perlu

func _on_solved() -> void:
	solved = true
	if circle:
		circle.on_puzzle_solved()
