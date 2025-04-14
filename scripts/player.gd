extends CharacterBody2D

# Physics parameters
const GRAVITY = 200.0      # Gravity force
const THRUST_POWER = 400.0 # Thrust power when boosting
const ROTATION_SPEED = 2.0 # Rotation speed in radians/second
const DAMPENING = 0.01     # Air resistance/natural slowing factor (very small to preserve inertia)

# Landing parameters
const MAX_SAFE_LANDING_VELOCITY = 100.0  # Maximum velocity for safe landing
const MAX_LANDING_ANGLE = 0.3  # Maximum angle (in radians) for safe landing (about 17 degrees)

# State tracking
var landed = false
var crashed = false

func _ready():
	# Initialize the player
	pass

func _physics_process(delta: float) -> void:
	# Skip physics if landed or crashed
	if landed or crashed:
		return
		
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	# Handle rotation
	if Input.is_action_pressed("rotate_left"):
		rotation -= ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_right"):
		rotation += ROTATION_SPEED * delta
	
	# Handle thrust/boost
	if Input.is_action_pressed("boost"):
		# Calculate thrust direction based on ship's rotation
		var thrust_direction = Vector2(sin(rotation), -cos(rotation))
		
		# Apply thrust in the direction the ship is facing
		velocity += thrust_direction * THRUST_POWER * delta
		
		# TODO: Add thruster particles/effects here
	
	# Apply very minor dampening/drag (to simulate space physics but still have some control)
	velocity = velocity.lerp(Vector2.ZERO, DAMPENING)
	
	# Update position and detect collisions
	var collision = move_and_collide(velocity * delta)
	
	# Handle collision
	if collision:
		_handle_collision(collision)

# Handle collision with the ground or other objects
func _handle_collision(collision):
	# Check if this is a safe landing
	print(collision)
	var is_safe = is_landing_safe()
	
	if is_safe:
		# Successful landing
		landed = true
		velocity = Vector2.ZERO
		print("Successful landing!")
		# TODO: Play landing sound, show landing success message
	else:
		# Crash landing
		crashed = true
		velocity = Vector2.ZERO
		print("Crash! Game over.")
		# TODO: Play crash sound, show crash visuals/particles, show game over message

# Function to check if landing is safe
func is_landing_safe() -> bool:
	# Check velocity (not too fast)
	var speed_ok = velocity.length() < MAX_SAFE_LANDING_VELOCITY
	
	# Check angle (not too tilted)
	# Calculate how upright the ship is (1.0 = perfect, 0.0 = sideways, -1.0 = upside down)
	var angle_ok = abs(sin(rotation)) < MAX_LANDING_ANGLE
	
	return speed_ok && angle_ok

# Reset the player for a new attempt
func reset_player():
	landed = false
	crashed = false
	velocity = Vector2.ZERO
	rotation = 0
	# Reset position would be managed by the game scene
