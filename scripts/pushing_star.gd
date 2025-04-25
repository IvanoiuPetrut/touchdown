extends Node2D
@onready var pushing_zone: Area2D = $PushingZone

# Push force applied to player
@export_range(100.0, 1000.0, 10.0) var push_strength = 300.0
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals for pushing zone
	pushing_zone.body_entered.connect(_on_pushing_zone_body_entered)
	pushing_zone.body_exited.connect(_on_pushing_zone_body_exited)
	
	# Create particles for the pushing zone
	_create_pushing_zone_particles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Apply pushing force if player is in push zone
	if player != null and is_instance_valid(player):
		# Calculate direction from star to player (opposite of pulling)
		var direction = player.global_position - global_position
		
		# Normalize direction and apply push force
		direction = direction.normalized()
		
		# Update player velocity (applying repulsive force)
		player.velocity += direction * push_strength * delta
		
# When player enters the pushing zone
func _on_pushing_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player":
		player = body
		
# When player exits the pushing zone
func _on_pushing_zone_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player":
		player = null

# Create particles for the pushing zone
func _create_pushing_zone_particles() -> void:
	var particles = CPUParticles2D.new()
	add_child(particles)
	
	# Get the radius from the collision shape
	var radius = 100.0
	if pushing_zone.get_child_count() > 0:
		var shape = pushing_zone.get_child(0)
		if shape is CollisionShape2D and shape.shape is CircleShape2D:
			radius = shape.shape.radius
	
	# Configure particles with different style than pulling star
	particles.amount = 40
	particles.lifetime = 1.5
	particles.emission_shape = 1  # Circle shape (enum value 1)
	particles.emission_sphere_radius = radius * 0.6  # Particles start closer to center
	particles.direction = Vector2(0, 0)
	particles.spread = 180
	particles.gravity = Vector2(0, 0)
	particles.initial_velocity_min = 20.0  # Faster particles
	particles.initial_velocity_max = 40.0  # Faster particles
	particles.radial_accel_min = 50  # Particles accelerate outward
	particles.radial_accel_max = 100
	particles.scale_amount_min = 0.5
	particles.scale_amount_max = 2.0
	particles.color = Color(0.2, 0.6, 0.9, 0.5)  # Blue color with transparency
	particles.color_ramp = _create_particle_gradient()
	
# Create a gradient for the particles
func _create_particle_gradient() -> Gradient:
	var gradient = Gradient.new()
	gradient.colors = [Color(0.2, 0.8, 1.0, 0.7), Color(0.1, 0.3, 1.0, 0.0)]
	gradient.offsets = [0.0, 1.0]
	return gradient
