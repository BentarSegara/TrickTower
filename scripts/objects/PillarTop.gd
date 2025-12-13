extends StaticBody2D

@export var bottom_pillar_path: NodePath
@export var circle_path: NodePath

@onready var bottom = get_node(bottom_pillar_path)
@onready var circle = get_node(circle_path)

var solved: bool = false

func trigger(action_type: String) -> void:
	if solved:
		return
	if action_type != "push":
		return

	if not bottom.stabilized:
		bottom._crush_player()
		return

	_press_rune_and_solve()

func _press_rune_and_solve() -> void:
	solved = true
	# efek tekan rune di belakang pilar di sini
	if circle:
		circle.on_puzzle_solved()
