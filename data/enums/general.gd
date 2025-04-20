extends Node

enum PlanetColorPairs {
	BLUE_GREEN,
	RED_ORANGE,
	PURPLE_PINK,
}

# Dictionary to get the actual color values for each planet type
const PLANET_COLORS = {
	PlanetColorPairs.BLUE_GREEN: ["#fcb08c", "#a5b7d4"],
	PlanetColorPairs.RED_ORANGE: ["#b2d942", "#166e7a"],
	PlanetColorPairs.PURPLE_PINK: ["#6ceded", "#6f1d5c"],
}

# Function to get colors for a specific planet type
func get_planet_colors(planet_type: int) -> Array:
	if PLANET_COLORS.has(planet_type):
		return PLANET_COLORS[planet_type]
	return ["#ffffff", "#cccccc"]  # Default fallback colors
