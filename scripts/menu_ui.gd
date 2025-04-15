extends CanvasLayer

@onready var planet_1: AnimatedTextureRect = %Planet1
@onready var planet_2: AnimatedTextureRect = %Planet2
@onready var planet_3: AnimatedTextureRect = %Planet3

@onready var btn_previous_planet: Button = %BtnPreviousPlanet
@onready var btn_next_planet: Button = %BtnNextPlanet

var current_planet_id : int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_make_planets_invisible()
	_make_planet_visible(current_planet_id)
	_update_planet_selector_btns()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _make_planet_visible(id: int):
	match id:
		1:
			if(Levels.Database["world_1"].unlocked):
				planet_1.visible = true
		2:
			if(Levels.Database["world_2"].unlocked):
				planet_2.visible = true
		3:
			if(Levels.Database["world_3"].unlocked):
				planet_3.visible = true
	
func _make_planets_invisible():
		planet_1.visible = false
		planet_2.visible = false
		planet_3.visible = false

func _update_planet_selector_btns():
	# Check if there's a previous planet available
	if current_planet_id > 1:
		btn_previous_planet.disabled = false
	else:
		btn_previous_planet.disabled = true
	
	# Check if there's a next planet available AND if it's unlocked
	if current_planet_id < 3 and Levels.Database["world_" + str(current_planet_id + 1)].unlocked:
		btn_next_planet.disabled = false
	else:
		btn_next_planet.disabled = true

func _on_btn_previous_planet_pressed() -> void:
	if current_planet_id > 1:
		current_planet_id -= 1
		_make_planets_invisible()
		_make_planet_visible(current_planet_id)
		_update_planet_selector_btns()

func _on_btn_next_planet_pressed() -> void:
	if current_planet_id < 3 and Levels.Database["world_" + str(current_planet_id + 1)].unlocked:
		current_planet_id += 1
		_make_planets_invisible()
		_make_planet_visible(current_planet_id)
		_update_planet_selector_btns()
