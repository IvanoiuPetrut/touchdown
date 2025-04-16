extends Node2D

@onready var player: CharacterBody2D = %Player
@onready var blue_stars: Sprite2D = $Node2D/BlueStars
@onready var red_stars: Sprite2D = $Node2D/RedStars
@onready var white_20: Sprite2D = $Node2D/White20
@onready var white_40: Sprite2D = $Node2D/White40
@onready var white_60: Sprite2D = $Node2D/White60
@onready var white_80: Sprite2D = $Node2D/White80
@onready var white_100: Sprite2D = $Node2D/White100
@onready var big_stars: Sprite2D = $Node2D/BigStars
@onready var small_stars: AnimatedSprite2D = $Node2D/SmallStars
@onready var big_stars_2: AnimatedSprite2D = $Node2D/BigStars2


# Parallax factors (lower = moves less, higher = moves more)
var parallax_layers = []
var base_positions = []

func _ready() -> void:
	# Setup parallax layers with different movement factors
	parallax_layers = [
		{"sprite": blue_stars, "factor": 0.02},
		{"sprite": red_stars, "factor": 0.04},
		{"sprite": white_20, "factor": 0.06},
		{"sprite": white_40, "factor": 0.08},
		{"sprite": white_60, "factor": 0.10},
		{"sprite": white_80, "factor": 0.12},
		{"sprite": white_100, "factor": 0.14},
		{"sprite": big_stars, "factor": 0.16},
		{"sprite": small_stars, "factor": 0.18},
		{"sprite": big_stars_2, "factor": 0.20}
	]
	
	# Store original positions
	for layer in parallax_layers:
		base_positions.append(layer.sprite.position)


func _process(delta: float) -> void:
	if player:
		# Get player velocity
		var player_velocity = player.velocity
		
		# Apply parallax effect to each layer
		for i in range(parallax_layers.size()):
			var layer = parallax_layers[i]
			var base_pos = base_positions[i]
			
			# Calculate offset based on player velocity and layer factor
			# We negate the velocity to create a parallax effect (background moves opposite to player)
			var offset = -player_velocity * layer.factor
			
			# Apply offset to sprite position
			layer.sprite.position = base_pos + offset
