extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneManager.change_scene('res://scenes/floors/Floor2_IllusionOfTruth.tscn')
