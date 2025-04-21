extends CanvasLayer

@onready var back_btn: Button = $Panel/VBoxContainer/ContainerFailedButtons/Back
@onready var retry_btn: Button = $Panel/VBoxContainer/ContainerFailedButtons/Retry
@onready var retry_btn2: Button = $Panel/VBoxContainer/ContainerSuccessuttons/Retry
@onready var continue_btn: Button = $Panel/VBoxContainer/ContainerSuccessuttons/Continue

signal button_clicked(action: String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
