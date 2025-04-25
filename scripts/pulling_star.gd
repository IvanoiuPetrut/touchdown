extends Node2D
@onready var area_2d: Area2D = $Area2D
@onready var attract_zone: Area2D = $AttractZone
@onready var kill_zone: Area2D = $KillZone

# Pull force applied to player
@export_range(100.0, 1000.0, 10.0) var pull_strength = 300.0
var player = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect signals for both zones
	attract_zone.body_entered.connect(_on_attract_zone_body_entered)
	attract_zone.body_exited.connect(_on_attract_zone_body_exited)
	kill_zone.body_entered.connect(_on_kill_zone_body_entered)
	
	# Create particles for the attract zone
	_create_attract_zone_particles()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Apply pulling force if player is in attract zone
	if player != null and is_instance_valid(player):
		# Calculate direction from player to star
		var direction = global_position - player.global_position
		
		# Normalize direction and apply pull force
		direction = direction.normalized()
		
		# Update player velocity (applying gravitational pull)
		player.velocity += direction * pull_strength * delta
		
# When player enters the attraction zone
func _on_attract_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player":
		player = body
		
# When player exits the attraction zone
func _on_attract_zone_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player":
		player = null
		
# When player enters the kill zone
func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "Player":
		# Call the player's crash function if they enter kill zone
		if body.has_method("_crash"):
			body._crash()
			
# Create particles for the attract zone
func _create_attract_zone_particles() -> void:
	var particles = CPUParticles2D.new()
	add_child(particles)
	
	# Get the radius from the collision shape
	var radius = 100.0
	if attract_zone.get_child_count() > 0:
		var shape = attract_zone.get_child(0)
		if shape is CollisionShape2D and shape.shape is CircleShape2D:
			radius = shape.shape.radius
	
	# Configure particles
	particles.amount = 30
	particles.lifetime = 2.0
	particles.emission_shape = 1  # Circle shape (enum value 1)
	particles.emission_sphere_radius = radius
	particles.direction = Vector2(0, 0)
	particles.spread = 180
	particles.gravity = Vector2(0, 0)
	particles.initial_velocity_min = 5.0
	particles.initial_velocity_max = 15.0
	particles.orbit_velocity_min = 0.5
	particles.orbit_velocity_max = 1.0
	particles.scale_amount_min = 1.0
	particles.scale_amount_max = 2.0
	particles.color = Color(0.9, 0.6, 0.1, 0.5)  # Golden color with transparency
	particles.color_ramp = _create_particle_gradient()
	
# Create a gradient for the particles
func _create_particle_gradient() -> Gradient:
	var gradient = Gradient.new()
	gradient.colors = [Color(1.0, 0.8, 0.2, 0.7), Color(1.0, 0.3, 0.1, 0.0)]
	gradient.offsets = [0.0, 1.0]
	return gradient
