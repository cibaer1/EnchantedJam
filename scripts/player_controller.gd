
extends CharacterBody2D
@onready var ui_controller: UIController = $"../CanvasLayer"

@export var human_stats: animal_stats
@export var cat_stats: animal_stats
@export var phantom_cam: PhantomCamera2D

@export var look_down_follow_offset: Vector2
@export var default_follow_offset: Vector2




var collider: CollisionShape2D

var human_sprite: Sprite2D
var cat_sprite: Sprite2D
var current_stats: animal_stats


var current_animal: String = "Nothing"

var jump_velocity: float
var gravity_up: float
var gravity_down: float
var coyote_counter = 0.0;
var is_jump_coming = false


func _ready() -> void:
	ui_controller.selected_animal.connect(animal_transform)
	collider = $CollisionShape2D
	
	human_sprite = $HumanSprite
	cat_sprite = $CatSprite
	
	
	set_collider_size(3, 13)
	current_stats = human_stats
	
	calculate_jump_values()
	
	phantom_cam.follow_offset = default_follow_offset

func set_collider_size(radius: float, height: float):
	var capsule := collider.shape as CapsuleShape2D
	capsule.radius = radius
	capsule.height = height
	
func calculate_jump_values() -> void:
	gravity_up = 2.0 * current_stats.jump_height / (current_stats.time_to_apex * current_stats.time_to_apex)
	gravity_down = 2.0 * current_stats.jump_height / (current_stats.time_to_fall * current_stats.time_to_fall)
	jump_velocity = -2.0 * current_stats.jump_height / current_stats.time_to_apex




func _physics_process(delta: float) -> void:
	# Add the gravity.
	
	
	if not is_on_floor():
		var g = gravity_up if velocity.y < 0 else gravity_down
		velocity.y += g * delta
		velocity.y = min(velocity.y, current_stats.max_fall_speed)

	if is_on_floor():
		coyote_counter = current_stats.coyote_time
	else:
		coyote_counter -= delta
	
	
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(self.global_position, Vector2(self.global_position.x, self.global_position.y + 100))
	var result = space_state.intersect_ray(query)
	var floor_dist = 1000
	if result:
		var result_pos: Vector2 = result.position
		floor_dist = result_pos.distance_to(self.global_position)
	if floor_dist < current_stats.jump_buffer_size and Input.is_action_just_pressed("Jump"):
		is_jump_coming = true
	
		
	
	
	# Handle jump.
	if (Input.is_action_just_pressed("Jump") or is_jump_coming) and coyote_counter > 0:
		is_jump_coming = false
		velocity.y += jump_velocity
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y *= current_stats.jump_cutoff
	if Input.is_action_just_pressed("Transform"):
		ui_controller.show_selection_wheel()
	if Input.is_action_just_released("Transform"):
		ui_controller.hide_selection_wheel()
	if Input.is_action_just_pressed("Down"):
		phantom_cam.follow_offset = look_down_follow_offset
	if Input.is_action_just_released("Down"):
		phantom_cam.follow_offset = default_follow_offset
		
		

	
	var direction := Input.get_axis("MoveW", "MoveE")
	var target_speed = direction * current_stats.speed
	var rate: float
	#print(direction)
	#print (signf(velocity.x))
	if direction == signf(velocity.x): 
		if is_on_floor():
			rate = current_stats.acceleration
		else:
			rate = current_stats.acceleration * current_stats.air_control
	elif direction != signf(velocity.x): #turn
		if is_on_floor():
			rate = current_stats.turn_speed
		else:
			rate = current_stats.turn_speed * current_stats.air_control
		
	else: # decellerate
		if is_on_floor():
			rate = current_stats.deceleration
		else:
			rate = current_stats.deceleration * current_stats.air_break
		pass
	velocity.x = move_toward(velocity.x, target_speed, rate * delta)
	#print(move_toward(velocity.x, target_speed, rate * delta))
	
	
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
			calculate_jump_values()
		"Cat":
			set_collider_size(1.5, 10)
			#set all sprites except human to invisible and human to visible TODO make a flexible function for this
			cat_sprite.show()
			human_sprite.hide()
			#set all movement attributes TODO also make a flexible function for this
			current_stats = cat_stats
			current_animal = "Cat"
			calculate_jump_values()
			
	
	
