extends Node

enum PlanetColorPairs {
	PLANET_1,
	PLANET_2,
	PLANET_3,
}

# Dictionary to get the actual color values for each planet type
const PLANET_COLORS = {
	PlanetColorPairs.PLANET_1: ["#fcb08c", "#a5b7d4"],
	PlanetColorPairs.PLANET_2: ["#b2d942", "#166e7a"],
	PlanetColorPairs.PLANET_3: ["#6ceded", "#6f1d5c"],
}

# Function to get colors for a specific planet type
func get_planet_colors(planet_type: int) -> Array:
	if PLANET_COLORS.has(planet_type):
		return PLANET_COLORS[planet_type]
	return ["#ffffff", "#cccccc"]  # Default fallback colors
