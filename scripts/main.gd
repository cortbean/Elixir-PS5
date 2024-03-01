extends Node3D
var thread: Thread
var IP_ADDRESS = "192.168.13.2"
var PORT = 1234

# Engine functions
# Called when the node enters the scene tree for the first time.
func _ready():
	print("maingd ready func")
	thread = Thread.new()
	# You can bind multiple arguments to a function Callable.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		pass
		

func _exit_tree():
	thread.wait_to_finish()	# Thread must be disposed (or "joined"), for portability.
	
	
# Signals functions
func _on_quit_pressed():
	get_tree().quit()

func _on_connect_pressed():
	# IP address REGEX before starting connection
	
	# Start thread
	thread.start(_thread_function.bind("Network thread"))
	
	# Disable button before having a connection
	get_node("AspectRatioContainer/GridContainer/btn_Connect").enable = false


# Thread functions under this comment
# The argument is the bound data passed from start().
func _thread_function(userdata):
	
	# Print the userdata ("Wafflecopter")
	print("I'm a thread! Userdata is: ", userdata)
	
	# Initiate communication to WebSocket server (RPI)
	
	# On return of status, change label to connected or Error. on UI
	
	# If error shutdown thread
	
	# If connected Keep connection alive 
	while true:
		# Read data of websocket and send data.
		pass
		
	
	

	
