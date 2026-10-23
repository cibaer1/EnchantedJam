extends Camera2D

@export var player_transform: CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	transform.x = player_transform.transform.x
	transform.y = player_transform.transform.y
	
