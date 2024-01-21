extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false

func _input(event):
	#Toggle debug panel
	if event.is_action_pressed("exit"):
		visible = !visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().change_scene_to_file("res://levels/control.tscn")
