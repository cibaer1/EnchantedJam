extends Node2D

@onready var ui_controller: UIController = $"../../CanvasLayer"

func _ready() -> void:
	ui_controller.selected_animal.connect(animal_transform)

func animal_transform(animal: String):
	print(animal)
	
