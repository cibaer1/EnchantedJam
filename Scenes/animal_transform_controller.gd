extends Node2D
@onready var ui_controller: UIController = $"../../CanvasLayer"


	
	

func animal_transform():
	ui_controller.show_selection_wheel()
func close_transform_menu():
	ui_controller.hide_selection_wheel()
