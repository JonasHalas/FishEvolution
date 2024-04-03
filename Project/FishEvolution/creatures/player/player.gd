extends CharacterBody2D

@export var size: float = 100
@export var movementSpeed: float = 100


#just to keep track of what direction the sprite should be when moving straight up or down
@onready var camera_2d = $Camera2D

# Get a reference to the body parts
@onready var head = get_node("CollisionShape2D/entireFish/head")
@onready var body = get_node("CollisionShape2D/entireFish/body")
@onready var tail = get_node("CollisionShape2D/entireFish/tail")
@onready var eye = get_node("CollisionShape2D/entireFish/eye")
@onready var finFront = get_node("CollisionShape2D/entireFish/finFront")
@onready var finBot = get_node("CollisionShape2D/entireFish/finBot")
@onready var finTop = get_node("CollisionShape2D/entireFish/finTop")
@onready var collision_shape_2d = $CollisionShape2D

var lastDirectionRight: bool = true
var inputDirection: Vector2 = Vector2(0,0)

func _ready():
	inputDirection = Vector2.ZERO


func _physics_process(_delta):
	
	#sets direction of character based on input
	inputDirection = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	#updates velocity
	velocity = inputDirection.normalized() * movementSpeed
	
	#allows us to move
	move_and_slide()
	
	rotate_character_body(inputDirection)


func _unhandled_input(_event: InputEvent) -> void:
	# zoom for testing
	if Input.is_action_just_pressed("Zoom In"):
		zoom_player_camera()
	if Input.is_action_just_pressed("Zoom Out"):
		zoom_player_camera_out()
	# Buttons for testing
	if Input.is_action_just_pressed("Test Button"):
		finFront.change_texture("res://art/fishParts/finFront/claw1.png")
	
	if Input.is_action_just_pressed("Test Button 2"):
		finTop.change_texture("res://art/fishParts/finTop/lightAntenna1.png")
	
	if Input.is_action_just_pressed("Test Button 3"):
		finBot.change_texture("res://art/fishParts/finBot/legs1.png")

			
# Rotate a CharacterBody2D node based on its velocity vector
func rotate_character_body(velocity: Vector2) -> void:
	#if fish is moving right and is not flipped, flip it
	if velocity.x < 0 && scale.y > 0:
		scale.y = -scale.y
	#if fish is moving right and is flipped, flip it back
	elif velocity.x > 0 && scale.y < 0:
		scale.y = -scale.y
	
		# rotates character according to direction. This can be simplified without degreeconversion, but in case i need the degrees in the future, im leavin as is
	if velocity != Vector2.ZERO:  # Ensure velocity is non-zero to avoid division by zero
		#calculates the radan
		var angle = atan2(velocity.y, velocity.x)
		# converts radan to degrees because radans are hard :(
		var degrees = rad_to_deg(angle)
		# Apply the rotation to the character body
		rotation_degrees = degrees


func zoom_player_camera() -> void:
	camera_2d.zoom = camera_2d.zoom + Vector2(0.1,0.1)


func zoom_player_camera_out() -> void:
	camera_2d.zoom = camera_2d.zoom - Vector2(0.1,0.1)
