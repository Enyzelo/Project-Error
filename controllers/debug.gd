extends PanelContainer

@onready var property_container = %VBoxContainer

#var property
var frames_per_second : String

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Global.debug = self
	
	#Hide debug on start
	visible = false
	
	#add_debug_property("FPS",frames_per_second)

func _input(event):
	#Toggle debug panel
	if event.is_action_pressed("cl_debug"):
		visible = !visible

func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title,true,false) #Try to find label node with the same name
	if !target: # If there is no current Label node for Property (ie. inital load)
		target = Label.new() # Create new label node
		property_container.add_child(target) # Add new node as child to VBox container
		target.name = title # Set name to title
		target.text = target.name + ": " + str(value) # Set text value 
	elif visible:
		target.text = title + ": " + str(value) # Update text value
		property_container.move_child(target, order) # Reorder property based on given order

#func add_debug_property(title : String,_value):
	#property = Label.new() # Create new label
	#property_container.add_child(property) # Add new node as child to VBox container
	#property.name = title # Set name to title
	#property.text = property.name + _value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if visible:
		
		frames_per_second = "%.2d" % (1.0/_delta) # Gets FPS every frame
		frames_per_second = "%.2d" % Engine.get_frames_per_second() # Gets frames per second every second
		#property.text = property.name + ": " + frames_per_second
