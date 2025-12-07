extends StaticBody2D

signal pad_pressed(pad_id: int)

@export var pad_id: int = 0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim.play("Idle")

func trigger(action_type: String) -> void:
	if action_type != "neutral":
		return
	
	anim.play("Active")
	await get_tree().create_timer(0.1).timeout
	anim.play("Idle")

	emit_signal("pad_pressed", pad_id)
