extends StaticBody2D

var stabilized: bool = false

func trigger(action_type: String) -> void:
	match action_type:
		"push":
			_crush_player()
		"pull":
			_stabilize()
		_:
			pass

func _stabilize() -> void:
	if stabilized:
		return
	stabilized = true
	# ubah sprite / animasi jika perlu

func _crush_player() -> void:
	var p = GameManager.player
	if p and p.has_method("die"):
		p.die()
