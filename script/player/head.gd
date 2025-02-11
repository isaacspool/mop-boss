extends Node3D

@onready var camera = $"../Camera"
@onready var cough_sound = $CoughSound
var cough_timer: Timer = null  # Holds the dynamically created Timer

func start_cough():
	if cough_timer:  # If the timer already exists, don't create another
		return
	
	# Create the timer dynamically
	cough_timer = Timer.new()
	cough_timer.wait_time = 1.75  # Set the interval to 1 second
	cough_timer.one_shot = false  # Make it repeat
	cough_timer.connect("timeout", _on_cough_timer_timeout)
	add_child(cough_timer)  # Add it as a child of the player
	cough_timer.start()  # Start the timer
	
	print("player starts coughing")

func stop_cough():
	if not cough_timer:  # If the timer doesn't exist, do nothing
		return
	
	# Stop and remove the timer
	cough_timer.stop()
	cough_timer.queue_free()
	cough_timer = null  # Clear the reference
	
	print("player stops coughing")

func _on_cough_timer_timeout():
	cough_sound.play()  # Play the cough sound
	camera.add_trauma_impulse(5.0)
