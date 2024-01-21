extends Control

func _on_option_button_item_selected(index):
	var current_selected = index
	
	if current_selected == 0:
		get_window().size = Vector2i(1024,546)
	if current_selected == 1:
		get_window().size = Vector2i(1289,720)
	if current_selected == 2:
		get_window().size = Vector2i(1600,900)
	if current_selected == 3:
		get_window().size = Vector2i(1920,1080)

func _on_option_button_2_item_selected(index):
	var current_selected = index
	
	if current_selected == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if current_selected == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://levels/control.tscn")
