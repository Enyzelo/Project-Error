class_name WalkingPlayerState

extends State


func update(_delta):
	if Global.player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
