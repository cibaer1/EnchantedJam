@tool
extends Control


@export var bkg_color: Color
@export var line_col: Color

@export var inner_radius: float = 64
@export var outer_radius: int = 256
@export var line_width: int = 4

func _draw():
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 256, line_col, line_width, true)
	
func _process(delta: float) -> void:
	queue_redraw()
