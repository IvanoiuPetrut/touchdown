extends Label

# Variables for subtle animation effects
var time: float = 0.0
var initial_scale: Vector2
var scale_x_speed: float = 1.5
var scale_y_speed: float = 1.2
var scale_x_amount: float = 0.05
var scale_y_amount: float = 0.03

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Store initial values
	initial_scale = scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Update timer
	time += delta
	
	# Subtle pinch and squeeze effect
	# X and Y scale slightly out of sync for a more organic feel
	var new_scale_x = initial_scale.x * (1.0 + sin(time * scale_x_speed) * scale_x_amount)
	var new_scale_y = initial_scale.y * (1.0 + cos(time * scale_y_speed) * scale_y_amount)
	
	scale = Vector2(new_scale_x, new_scale_y)
	
