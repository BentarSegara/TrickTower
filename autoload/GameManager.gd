extends Node

var player: CharacterBody2D = null
var current_spawn_position: Vector2 = Vector2.ZERO

func register_player(p: CharacterBody2D) -> void:
	player = p
	current_spawn_position = p.global_position

func set_spawn(pos: Vector2) -> void:
	current_spawn_position = pos

func respawn():
	if player:
		player.global_position = current_spawn_position
		player.velocity = Vector2.ZERO
