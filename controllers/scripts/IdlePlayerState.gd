class_name IdlePlayerState
extends State


func update(_delta):
	if Global.player.velocity.length() > 0.0 and Global.player.is_on_floor():
		transition.emit("WalkingPlayerState")
