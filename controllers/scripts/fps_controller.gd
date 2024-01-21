class_name Player
extends CharacterBody3D

@export var SPEED_DEFAULT : float = 5.0
@export var SPEED_CROUCH : float = 3.0
@export var SPEED_SPRINT : float = 7.0
@export var SPEED_WALK : float = 2.0
@export var ACCELERATION : float = 0.1
@export var DECELERATION : float = 0.25
@export var JUMP_VELOCITY : float = 4.5
@export var MOUSE_SENSITIVITY : float = 1
@export var M_YAW : float = 0.22
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var ANIMATIONPLAYER : AnimationPlayer
@export var CROUCH_SHAPECAST : Node3D

var _speed : float
var _mouse_input : bool = false
var _rotation_input : float
var _tilt_input : float
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
var _is_crouching : bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Define first and third person cam
enum cam_state{FIRST, THIRD}
var current_cam_state = cam_state.FIRST

func togglecam():
	match current_cam_state:
		cam_state.THIRD:
			$CameraController/Camera3D.make_current()
			current_cam_state = cam_state.FIRST
		cam_state.FIRST:
			$CameraController/SpringArm3D/Camera3D.make_current()
			current_cam_state = cam_state.THIRD

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY * M_YAW
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY * M_YAW

func _input(event):
	
	if event.is_action_pressed("exit"):
		get_tree().quit()
	
	# Check for imput to toggle between first and third person cam
	if event.is_action_pressed("togglecam"):
		togglecam()

func _update_camera(delta):
	# Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)

	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	CAMERA_CONTROLLER.rotation.z = 0.0

	_rotation_input = 0.0
	_tilt_input = 0.0

func _ready():
	
	Global.player = self
	# Get mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	CROUCH_SHAPECAST.add_exception($".")
	_speed = SPEED_DEFAULT

func _physics_process(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("+jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func _process(delta):
	
	Global.debug.add_property("MovSpeed",_speed, 2)
	Global.debug.add_property("MRotation",_mouse_rotation, 3)
	Global.debug.add_property("Velocity",velocity, 4)
	Global.debug.add_property("Accel", ACCELERATION, 5)
	Global.debug.add_property("Decel", DECELERATION, 6)
	Global.debug.add_property("G", gravity, 7)
	Global.debug.add_property("OVHC",CROUCH_SHAPECAST.is_colliding(), 8)
	Global.debug.add_property("Res: ", DisplayServer.get_primary_screen(), 9)
	# Update camera movement based on mouse movement
	_update_camera(delta)

func update_gravity(delta) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

func update_input(_speed: float, ACCELERATION: float, DECELERATION: float) -> void:
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("+left", "+right", "+forward", "+backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * _speed, ACCELERATION)
		velocity.z = lerp(velocity.z, direction.z * _speed, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION)
		velocity.z = move_toward(velocity.z, 0, DECELERATION)

func update_velocity() -> void:
	move_and_slide()
