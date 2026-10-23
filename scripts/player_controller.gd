
extends CharacterBody2D
@onready var ui_controller: UIController = $"../CanvasLayer"

@export var human_jump_velocity = -100
@export var human_speed = 150
@export var cat_jump_velocity = -400
@export var cat_speed = 250


var SPEED = 300.0
var JUMP_VELOCITY = -400.0

var collider: CollisionShape2D

var human_sprite: Sprite2D
var cat_sprite: Sprite2D

var current_animal: String = "Nothing"

func _ready() -> void:
	ui_controller.selected_animal.connect(animal_transform)
	collider = $CollisionShape2D
	
	human_sprite = $HumanSprite
	cat_sprite = $CatSprite
	
	
	set_collider_size(3, 13)
	JUMP_VELOCITY = human_jump_velocity
	SPEED = human_speed

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
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("Transform"):
		ui_controller.show_selection_wheel()
	if Input.is_action_just_released("Transform"):
		ui_controller.hide_selection_wheel()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("MoveW", "MoveE")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
			SPEED = human_speed
			JUMP_VELOCITY = human_jump_velocity
		"Cat":
			set_collider_size(1.5, 10)
			#set all sprites except human to invisible and human to visible TODO make a flexible function for this
			cat_sprite.show()
			human_sprite.hide()
			#set all movement attributes TODO also make a flexible function for this
			SPEED = cat_speed
			JUMP_VELOCITY = cat_jump_velocity
			
	
	
