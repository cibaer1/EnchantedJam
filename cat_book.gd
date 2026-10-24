extends Area2D


func _ready() -> void:
	$AnimationPlayer.play("cat_book_float")


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#play pickup animation
		$"../CanvasLayer/selection_wheel".add_option("Cat")
		self.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		
