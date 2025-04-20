extends CharacterBody2D

@onready var thurster_sound: AudioStreamPlayer2D = $ThursterSound
@onready var explosion_sound: AudioStreamPlayer2D = $ExplosionSound
@onready var success_landing: AudioStreamPlayer2D = $successLanding
@onready var thurster_particles: CPUParticles2D = $ThursterParticles
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_2d: Camera2D = %Camera2D

# Camera settings
const CAMERA_OFFSET = Vector2(-43, 0)  # Offset camera to the left of player
const BOOST_SHAKE_AMOUNT = 1.0     # Intensity of camera shake when boosting

# Physics parameters
const GRAVITY = 200.0      # Gravity force
const THRUST_POWER = 400.0 # Thrust power when boosting
const ROTATION_SPEED = 2.0 # Rotation speed in radians/second
const DAMPENING = 0.01     # Air resistance/natural slowing factor (very small to preserve inertia)

# Landing parameters
const MAX_SAFE_LANDING_VELOCITY = 100.0  # Maximum velocity for safe landing
const MAX_LANDING_ANGLE = 0.3  # Maximum angle (in radians) for safe landing (about 17 degrees)

# Game variables - for UI display and game mechanics
var fuel = 100.0           # Starting fuel amount
var score = 0              # Player score
var mission_time = 0.0     # Time elapsed in current mission
var altitude = 0.0         # Current altitude from surface
var horizontal_speed = 0.0 # Horizontal speed component
var vertical_speed = 0.0   # Vertical speed component
var mission_status = "IN PROGRESS" # Current mission status

# State tracking
var landed = false
var crashed = false

# Fuel consumption
const FUEL_CONSUMPTION_RATE = 10.0 # Fuel used per second when boosting

# Signal for UI updates
signal stats_changed

# Altitude calculation
@onready var ray_cast = $RayCastDistanceToGround

func _ready():
	# Initialize the player
	# Make sure raycast is enabled and pointing downward
	if ray_cast:
		ray_cast.enabled = true
		ray_cast.target_position = Vector2(0, 1000)  # Long enough to hit ground
	
	# Set camera offset
	if camera_2d:
		camera_2d.offset = CAMERA_OFFSET

func _physics_process(delta: float) -> void:
	# Skip physics if landed or crashed
	if landed or crashed:
		# Make sure thruster sound is stopped when landed or crashed
		if thurster_sound.playing:
			thurster_sound.stop()
		return
		
	# Check if player ran out of fuel and is not yet landed
	if fuel <= 0 and !landed and velocity.y > 0:
		# If player is falling and has no fuel, check if they're in a safe landing position
		var landing_possible = _check_landing_possible()
		if !landing_possible:
			# If landing is not possible, consider it a failed mission
			_out_of_fuel()
	
	# Update mission time
	mission_time += delta
		
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	# Handle rotation
	if Input.is_action_pressed("rotate_left"):
		rotation -= ROTATION_SPEED * delta
	if Input.is_action_pressed("rotate_right"):
		rotation += ROTATION_SPEED * delta
	
	# Handle thrust/boost
	if Input.is_action_pressed("boost"):
		# Only boost if we have fuel
		if fuel > 0:
			# Calculate thrust direction based on ship's rotation
			var thrust_direction = Vector2(sin(rotation), -cos(rotation))
			
			# Apply thrust in the direction the ship is facing
			velocity += thrust_direction * THRUST_POWER * delta
			
			# Consume fuel
			fuel = max(0, fuel - FUEL_CONSUMPTION_RATE * delta)
			
			# Play thruster sound if it's not already playing
			if !thurster_sound.playing:
				thurster_sound.play()
			
			# Enable thruster particles
			thurster_particles.emitting = true
			
			# Add camera shake when boosting
			if camera_2d:
				camera_2d.offset = CAMERA_OFFSET + Vector2(
					randf_range(-BOOST_SHAKE_AMOUNT, BOOST_SHAKE_AMOUNT),
					randf_range(-BOOST_SHAKE_AMOUNT, BOOST_SHAKE_AMOUNT)
				)
		else:
			# Stop thruster sound when out of fuel
			if thurster_sound.playing:
				thurster_sound.stop()
			# Disable thruster particles when out of fuel
			thurster_particles.emitting = false
	else:
		# Stop thruster sound when not boosting
		if thurster_sound.playing:
			thurster_sound.stop()
		# Disable thruster particles when not boosting
		thurster_particles.emitting = false
		
		# Reset camera position when not boosting
		if camera_2d:
			camera_2d.offset = CAMERA_OFFSET
	
	# Apply very minor dampening/drag (to simulate space physics but still have some control)
	velocity = velocity.lerp(Vector2.ZERO, DAMPENING)
	
	# Calculate speed components for UI
	horizontal_speed = abs(velocity.x)
	vertical_speed = velocity.y
	
	# Calculate altitude using raycast
	_update_altitude()
	
	# Emit signal for UI updates
	emit_signal("stats_changed")
	
	# Update position and detect collisions
	var collision = move_and_collide(velocity * delta)
	
	# Handle collision
	if collision:
		_handle_collision(collision)

# Calculate altitude using raycast
func _update_altitude():
	if ray_cast:
		# Reset the raycast to ensure it's pointing down relative to ship orientation
		ray_cast.target_position = Vector2(0, 1000).rotated(rotation)
		
		if ray_cast.is_colliding():
			# Calculate the distance to the collision point
			var collision_point = ray_cast.get_collision_point()
			altitude = global_position.distance_to(collision_point)
		else:
			# If raycast doesn't hit anything, use a placeholder value
			altitude = 1000.0  # Max altitude

# Handle collision with the ground or other objects
func _handle_collision(collision):
	var collider = collision.get_collider()
	print("Collided with: ", collider.name)
	
	# Check what type of object we collided with
	if collider.name == "TileMapLayer" or collider is TileMap:
		# Collision with terrain - always crash
		_crash()
	elif collider.name == "LandingPad" or collider.get_parent().name == "LandingPad":
		# We hit the landing pad, check if it's a safe landing
		var is_safe = is_landing_safe()
		if is_safe:
			_land_successfully()
		else:
			_crash()
	else:
		# Any other collision results in a crash
		_crash()


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
	
	# Reset game variables
	fuel = 100.0
	mission_time = 0.0
	mission_status = "IN PROGRESS"
	altitude = 0.0
	horizontal_speed = 0.0
	vertical_speed = 0.0
	
	# Ensure thruster particles are off
	thurster_particles.emitting = false
	animation_player.play("RESET")
	
	# Score is not reset here as it should persist across attempts
	
	# Notify UI
	emit_signal("stats_changed")
	
	# Reset position would be managed by the game scene

func _crash():
	print("Crash!")
	crashed = true
	velocity = Vector2.ZERO
	mission_status = "CRASHED"
	
	# Play explosion sound
	explosion_sound.play()
	
	# Start animation for explosion
	animation_player.play("explosion")
	
	# Reduce score on crash
	score = max(0, score - 25)
	
	# Notify UI
	emit_signal("stats_changed")

func _land_successfully():
	print("Landed successfully!")
	landed = true
	mission_status = "LANDED"
	
	# Play success landing sound
	success_landing.play()
	
	# Calculate landing score based on remaining fuel, time, and precision
	var fuel_bonus = fuel * 2
	var time_bonus = max(0, 300 - mission_time) # Bonus decreases with time
	var precision_bonus = 100 # Placeholder - could be based on distance to target
	
	var landing_score = fuel_bonus + time_bonus + precision_bonus
	score += landing_score
	
	print("Landing score: ", landing_score)
	
	# Notify UI
	emit_signal("stats_changed")

# Function to check if a safe landing is still possible with no fuel
func _check_landing_possible() -> bool:
	# This is a simplified check - could be more complex depending on game mechanics
	# Check if there's a landing pad below the player and we're not moving too fast laterally
	return ray_cast.is_colliding() and ray_cast.get_collider().name == "LandingPad" and abs(velocity.x) < MAX_SAFE_LANDING_VELOCITY / 2

# Handle out of fuel situation
func _out_of_fuel():
	print("Out of fuel!")
	crashed = true
	mission_status = "OUT OF FUEL"
	
	# Play explosion sound since this is also a failure
	explosion_sound.play()
	
	# Reduce score on fuel-out (less than a crash)
	score = max(0, score - 15)
	
	# Notify UI
	emit_signal("stats_changed")
