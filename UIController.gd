extends CanvasLayer
class_name UIController

@export var selection_wheel: Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func show_selection_wheel():
	selection_wheel.show()
func hide_selection_wheel():
	selection_wheel.hide()
	
