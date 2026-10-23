
extends CharacterBody2D
@onready var ui_controller: UIController = $"../CanvasLayer"

@export var human_stats: animal_stats
@export var cat_stats: animal_stats




var collider: CollisionShape2D

var human_sprite: Sprite2D
var cat_sprite: Sprite2D
var current_stats: animal_stats


var current_animal: String = "Nothing"

func _ready() -> void:
	ui_controller.selected_animal.connect(animal_transform)
	collider = $CollisionShape2D
	
	human_sprite = $HumanSprite
	cat_sprite = $CatSprite
	
	
	set_collider_size(3, 13)
	current_stats = human_stats

func set_collider_size(radius: float, height: float):
	var capsule := collider.shape as CapsuleShape2D
	capsule.radius = radius
	capsule.height = height

func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = current_stats.jump_velocity
	if Input.is_action_just_pressed("Transform"):
		ui_controller.show_selection_wheel()
	if Input.is_action_just_released("Transform"):
		ui_controller.hide_selection_wheel()
		

	
	var direction := Input.get_axis("MoveW", "MoveE")
	var target_speed = direction * current_stats.speed
	var rate: float
	#print(direction)
	#print (signf(velocity.x))
	if direction == signf(velocity.x): 
		#accellerate
		rate = current_stats.acceleration
	elif direction != signf(velocity.x): #turn
		rate = current_stats.turn_speed
		
	else: # decellerate
		rate = current_stats.deceleration
		pass
	velocity.x = move_toward(velocity.x, target_speed, rate * delta)
	print(move_toward(velocity.x, target_speed, rate * delta))
	
	
	move_and_slide()

func die(): 
	get_tree().reload_current_scene()

func animal_transform(selected_animal: String):
	current_animal = selected_animal
	match selected_animal:
		"Nothing":
			pass
		"Human":
			set_collider_size(3, 13)
			#set all sprites except human to invisible and human to visible TODO make a flexible function for this
			cat_sprite.hide()
			human_sprite.show()
			#set all movement attributes TODO also make a flexible function for this
			current_stats = human_stats
			current_animal = "Human"
			
		"Cat":
			set_collider_size(1.5, 10)
			#set all sprites except human to invisible and human to visible TODO make a flexible function for this
			cat_sprite.show()
			human_sprite.hide()
			#set all movement attributes TODO also make a flexible function for this
			current_stats = cat_stats
			current_animal = "Cat"
			
	
	
