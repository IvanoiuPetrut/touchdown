extends Node2D

const GeneralEnums = preload("res://data/enums/general.gd")

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
@onready var background: Sprite2D = $Background


# Parallax factors (lower = moves less, higher = moves more)
var parallax_layers = []
var base_positions = []
var initial_player_position = Vector2.ZERO

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
	
	# Set initial values
	if player:
		initial_player_position = player.position
		_follow_player()


func _process(delta: float) -> void:
	_follow_player()
	_apply_parallax_effect()

func _follow_player() -> void:
	if player:
		position = player.position
		# Move the node up by half the screen height to center the player
		position.y -= get_viewport_rect().size.y / 2
		position.x -= get_viewport_rect().size.x / 2

func _apply_parallax_effect() -> void:
	if player:
		# Calculate player's movement from initial position
		var player_movement = player.position - initial_player_position
		
		# Apply parallax effect to each layer
		for i in range(parallax_layers.size()):
			var layer = parallax_layers[i]
			var base_pos = base_positions[i]
			
			# Calculate offset based on player position and layer factor
			var offset = -player_movement * layer.factor
			
			# Apply offset to sprite position
			layer.sprite.position = base_pos + offset

func _set_gradient(color_index: int):
	var planet_colors = GeneralEnums.new().get_planet_colors(color_index)
	if background:
		background.material.set_shader_parameter("first_color", Color(planet_colors[0]))
		background.material.set_shader_parameter("second_color", Color(planet_colors[1]))
