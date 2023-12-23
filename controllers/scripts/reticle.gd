extends CenterContainer

@export var RETICLE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0
@export var RETICLE_DISTANCE : float = 1.5
@export var DOT_RADIUS : float = 1.0
@export var DOT_COLOR : Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	adjust_reticle_line()

func _draw():
	draw_circle(Vector2(0,0), DOT_RADIUS,DOT_COLOR)

func adjust_reticle_line():
	var velocity = PLAYER_CONTROLLER.get_real_velocity()
	var origin = Vector3(0,0,0)
	var pos = Vector2(0,0)
	var speed = origin.distance_to(velocity)

# Adjust Reticle Line Position, [Top 0, Left 1, Right 2 Bottom 3]
	RETICLE_LINES[0].position = lerp(RETICLE_LINES[0].position, pos + Vector2(0, -speed * RETICLE_DISTANCE), RETICLE_SPEED)
	RETICLE_LINES[1].position = lerp(RETICLE_LINES[1].position, pos + Vector2(-speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
	RETICLE_LINES[2].position = lerp(RETICLE_LINES[2].position, pos + Vector2(speed * RETICLE_DISTANCE, 0), RETICLE_SPEED)
	RETICLE_LINES[3].position = lerp(RETICLE_LINES[3].position, pos + Vector2(0, speed * RETICLE_DISTANCE), RETICLE_SPEED)
