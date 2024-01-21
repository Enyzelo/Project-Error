class_name SprintingPlayerState
extends PlayerMovementState

@export var SPEED : float = 8.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var TOP_ANIM_SPEED: float = 1.6

func enter() -> void:
	ANIMATION.play("run_unarmed",0.5,1.0)

func update(_delta):
	PLAYER.update_gravity(_delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELERATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_pressed("+crouch"):
		transition.emit("CrouchingPlayerState")
	
	if Input.is_action_just_released("+sprint") and PLAYER.is_on_floor():
		transition.emit("WalkingPlayerState")

func set_animation_speed(spd) -> void:
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
