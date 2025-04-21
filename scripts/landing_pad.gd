extends StaticBody2D

#@onready var arrow: TextureRect = $ArrowLayer/Arrow
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var arrow: Sprite2D = $Arrow

# Viewport dimensions and UI margin
const VIEWPORT_WIDTH = 640
const VIEWPORT_HEIGHT = 360
const UI_LEFT_MARGIN = 40

func _ready() -> void:
	# Initialize the arrow
	arrow.visible = false
	# No need to set pivot offset for Sprite2D as it rotates around its origin by default

func _process(delta: float) -> void:
	update_arrow_position()

func update_arrow_position() -> void:
	# Get the global position of the landing pad
	var global_pos = global_position
	
	# Get the viewport rect
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	var camera_pos = camera.global_position
	var view_rect = Rect2(
		camera_pos - Vector2(VIEWPORT_WIDTH, VIEWPORT_HEIGHT) / 2,
		Vector2(VIEWPORT_WIDTH, VIEWPORT_HEIGHT)
	)
	
	# Check if landing pad is outside of the viewport
	if not view_rect.has_point(global_pos):
		# Show the arrow
		arrow.visible = true
		
		# Calculate direction to the landing pad from the center of the screen
		var screen_center = camera_pos
		var direction = global_pos - screen_center
		
		# Calculate angle - adjust by -90 degrees (or -PI/2 radians) to make the top point in the direction
		# This assumes the sprite's default orientation has its top pointing up (0 degrees)
		var angle = direction.angle() - PI/2
		arrow.rotation = angle
		
		# Calculate safe screen coordinates (avoiding the UI)
		var safe_width = VIEWPORT_WIDTH - UI_LEFT_MARGIN
		var x_center = (VIEWPORT_WIDTH + UI_LEFT_MARGIN) / 2
		
		# Calculate the arrow position at the edge of the screen
		var distance = min(safe_width, VIEWPORT_HEIGHT) / 2 - 30
		# Since we adjusted the angle for the arrow's rotation, we need to adjust it back for positioning
		var position_angle = direction.angle()
		var offset = Vector2(cos(position_angle), sin(position_angle)) * distance
		
		# Calculate screen position
		var screen_pos = Vector2(x_center, VIEWPORT_HEIGHT / 2) + offset
		
		# Constrain to viewport boundaries with UI margin
		screen_pos.x = clamp(screen_pos.x, UI_LEFT_MARGIN + 20, VIEWPORT_WIDTH - 20)
		screen_pos.y = clamp(screen_pos.y, 20, VIEWPORT_HEIGHT - 20)
		
		# Convert screen position to global position for the Sprite2D
		var viewport = get_viewport()
		arrow.global_position = viewport.canvas_transform.affine_inverse() * screen_pos
	else:
		# Hide the arrow when landing pad is visible
		arrow.visible = false
